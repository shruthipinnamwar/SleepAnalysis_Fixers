# encoding: utf-8
#
# [2017] Elasticsearch Incorporated. All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Elasticsearch Incorporated and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to Elasticsearch Incorporated
# and its suppliers and may be covered by U.S. and Foreign Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from Elasticsearch Incorporated.
#

require "logstash/json"
require 'license_checker/license_reader'
require 'license_checker/x_pack_info'
java_import java.util.concurrent.Executors
java_import java.util.concurrent.TimeUnit

module LogStash
  module LicenseChecker

    class LicenseError < StandardError; end

    class LicenseManager
      include LogStash::Util::Loggable, Observable

      attr_reader :last_updated

      LICENSE_TYPES = :trial, :basic, :standard, :gold, :platinum

      def initialize (reader, feature, refresh_period=30, refresh_unit=TimeUnit::SECONDS)
        @license_reader = reader
        @feature = feature
        begin
            fetch_xpack_info
        rescue StandardError => e
          logger.error("Unable to retrieve license information from license server", :message => e.message, :class => e.class.name)
        end
        if @executor.nil?
            @executor = Executors.new_single_thread_scheduled_executor{ |runnable| create_daemon_thread (runnable)}
            @executor.schedule_at_fixed_rate(Proc.new{fetch_xpack_info}, refresh_period, refresh_period, refresh_unit)
        end
      end

      def current_xpack_info
        @xpack_info
      end

      def fetch_xpack_info
        fetched_license = nil
        begin
          unless xpack_installed?
            update_xpack_info(XPackInfo.xpack_not_installed)
            return
          end
          fetched_license = @license_reader.fetch_license
        rescue StandardError => e
          puts e.message
          logger.error('Unable to retrieve license information from license server', :message => e.message, :class => e.class.name)
        end
        update_xpack_info(XPackInfo.from_es_response(fetched_license))
      end

      def xpack_installed?
        @xpack_installed ||= @license_reader.xpack_installed?
      end

      private
      def update_xpack_info(xpack_info)
        if @xpack_info.nil? || !@xpack_info.license_match?(xpack_info)
          @xpack_info = xpack_info
          logger.debug('updating observers of xpack info change') if logger.debug?
          changed
          notify_observers(current_xpack_info)
        end
      end

      # Create a daemon thread for the license checker to stop this thread from keeping logstash running in the
      # event of shutdown
      def create_daemon_thread(runnable)
        thread = java.lang.Thread.new(runnable, "#{@feature}-license-manager")
        thread.set_daemon(true)
        thread
      end
    end
  end
end

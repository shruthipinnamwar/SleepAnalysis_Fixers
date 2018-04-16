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
java_import java.util.concurrent.Executors
java_import java.util.concurrent.TimeUnit

module LogStash
  module LicenseChecker
    class XPackInfo
      include LogStash::Util::Loggable

      LICENSE_TYPES = :trial, :basic, :standard, :gold, :platinum

      def initialize (license, installed=true)
        @license = license
        @installed = installed
      end

      def license_match?(license)
        @license == license
      end

      def method_missing(meth)
        if meth.to_s.match(/license_(.+)/)
          return nil if @license.nil?
          @license[$1]
        else
          super
        end
      end

      def installed?
        @installed
      end

      def license_available?
        !@license.nil?
      end

      def license_active?
        return false if @license.nil?
        license_status == 'active'
      end

      def license_one_of?(types)
        return false if @license.nil?
        types.include?(license_type)
      end

      def to_s
         "installed:#{installed?},
          license:#{@license.nil? ? '<no license loaded>' : @license.to_s},
          last_updated:#{@last_updated}}"
      end

      def self.from_es_response(es_response)
        if es_response.nil? or es_response['license'].nil?
          logger.warn("Nil response from License Server")
          XPackInfo.new(nil)
        else
          XPackInfo.new(es_response['license'])
        end
      end

      def self.xpack_not_installed
        XPackInfo.new(nil, false)
      end
    end
  end
end

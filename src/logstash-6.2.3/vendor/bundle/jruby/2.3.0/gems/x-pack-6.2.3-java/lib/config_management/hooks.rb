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
require "logstash/runner"
require "logstash/logging/logger"
require "config_management/bootstrap_check"
require "config_management/elasticsearch_source"
require "logstash/config/source_loader"
require "logstash/config/source/local"
require "logstash/config/source/multi_local"
require "logstash/config/source/modules"


module LogStash
  module ConfigManagement
    class Hooks
      include LogStash::Util::Loggable

      def before_bootstrap_checks(runner)
        if management?(runner)
          bootstrap_checks = LogStash::Runner::DEFAULT_BOOTSTRAP_CHECKS.dup

          # We only need to allow logstash to start without any parameters
          # and validate the ES parameters if needed
          bootstrap_checks.delete(LogStash::BootstrapCheck::DefaultConfig)
          bootstrap_checks << LogStash::ConfigManagement::BootstrapCheck
          runner.bootstrap_checks = bootstrap_checks
        end
      end

      def after_bootstrap_checks(runner)
        # If xpack is enabled we can safely remove the local source completely and just use
        # elasticsearch as the source of truth.
        #
        # The bootstrap check guards will make sure we can go ahead to load the remote config source
        if management?(runner)
          logger.debug("Removing the `Logstash::Config::Source::Local` and replacing it with `ElasticsearchSource`")
          runner.source_loader.remove_source(LogStash::Config::Source::Local)
          runner.source_loader.remove_source(LogStash::Config::Source::MultiLocal)
          runner.source_loader.remove_source(LogStash::Config::Source::Modules)
          source = LogStash::ConfigManagement::ElasticsearchSource.new(runner.settings)
          runner.source_loader.add_source(source)
        end
      end

      private
      def management?(runner)
        runner.setting("xpack.management.enabled")
      end
    end
  end
end

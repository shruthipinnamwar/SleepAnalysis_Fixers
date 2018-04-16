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
require "logstash/config/pipeline_config"
require "logstash/config/source/base"
require "logstash/config/source_loader"
require "logstash/logging/logger"
require "logstash/outputs/elasticsearch"
require "logstash/json"
require 'helpers/elasticsearch_options'
require "license_checker/licensed"


module LogStash
  module ConfigManagement
    class ElasticsearchSource < LogStash::Config::Source::Base
      include LogStash::Util::Loggable, LogStash::LicenseChecker::Licensed,
              LogStash::Helpers::ElasticsearchOptions

      class RemoteConfigError < LogStash::Error; end

      PIPELINE_INDEX = ".logstash"
      PIPELINE_TYPE = "doc"
      VALID_LICENSES = %w(trial standard gold platinum)
      FEATURE = 'management'

      def initialize(settings)
        super(settings)
        if @settings.get("xpack.management.enabled") && !@settings.get_setting("xpack.management.elasticsearch.password").set?
          raise ArgumentError.new("You must set the password using the \"xpack.management.elasticsearch.password\" in logstash.yml")
        end

        @es_options = es_options_from_settings('management', settings)

        if enabled?
          setup_license_checker(FEATURE)
          license_check(true)
        end
      end

      def match?
        @settings.get("xpack.management.enabled")
      end

      def config_conflict?
        false
      end

      def pipeline_configs
        logger.trace("Fetch remote config pipeline", :pipeline_ids => pipeline_ids)

        begin
          license_check(true)
        rescue LogStash::LicenseChecker::LicenseError => e
          if @cached_pipelines.nil?
            raise e
          else
            return @cached_pipelines
          end
        end

        response = fetch_config(pipeline_ids)

        if response["error"]
          raise RemoteConfigError, "Cannot find find configuration for pipeline_id: #{pipeline_ids}, server returned status: `#{response["status"]}`, message: `#{response["error"]}`"
        end

        if response["docs"].nil?
          logger.debug("Server returned an unknown or malformed document structure", :response => response)
          raise RemoteConfigError, "Elasticsearch returned an unknown or malformed document structure"
        end

        # Cache pipelines to handle the case where a remote configuration error can render a pipeline unusable
        # it is not reloadable
        @cached_pipelines = response["docs"].collect do |document|
          get_pipeline(document)
        end.compact
      end

      def get_pipeline(response)
        pipeline_id = response["_id"]

        if response["found"] == false
          logger.debug("Could not find a remote configuration for a specific `pipeline_id`", :pipeline_id => pipeline_id)
          return nil
        end

        config_string = response.fetch("_source", {})["pipeline"]

        raise RemoteConfigError, "Empty configuration for pipeline_id: #{pipeline_id}" if config_string.nil? || config_string.empty?

        config_part = org.logstash.common.SourceWithMetadata.new("x-pack-config-management", pipeline_id.to_s, config_string)

        # We don't support multiple pipeline or specific pipeline configuration so lets use the global
        # settings from the logstash.yml file
        settings = @settings.clone
        settings.set("pipeline.id", pipeline_id)
        LogStash::Config::PipelineConfig.new(self.class.name, pipeline_id.to_sym, config_part, settings)
      end

      # This is a bit of a hack until we refactor the ElasticSearch plugins
      # and extract correctly the http client, right now I am using the plugins
      # to deal with the certificates and the other SSL options
      #
      # But we have to silence the logger from the plugin, to make sure the
      # log originate from the `ElasticsearchSource`
      def build_client
        es = LogStash::Outputs::ElasticSearch.new(@es_options)
        new_logger = logger
        es.instance_eval { @logger = new_logger }
        es.build_client
      end

      def fetch_config(pipeline_ids)
        request_body_string = LogStash::Json.dump({ "docs" => pipeline_ids.collect { |pipeline_id| { "_id" => pipeline_id } } })
        client.post(config_path, {}, request_body_string)
      end

      def config_path
        "#{PIPELINE_INDEX}/#{PIPELINE_TYPE}/_mget"
      end

      def populate_license_state(xpack_info)
        license_state = { :state => :ok, :log_level => :info, :log_message => "Configuration Management License OK" }
        unless xpack_info.installed?
          return { :state => :error,
                   :log_level => :error,
                   :log_message => "X-Pack is installed on Logstash but not on Elasticsearch. Please install X-Pack on Elasticsearch to use the Configuration Management feature. Other features may be available."
          }
        end
        if xpack_info.license_available?
          unless xpack_info.license_active?
            license_state = { :state => :ok,
                              :log_level => :warn,
                              :log_message => 'Configuration Management feature requires a valid license. You can continue to use pipelines stored in Elasticsearch, but please contact your administrator to update your license.'
            }
          end
          unless xpack_info.license_one_of?(VALID_LICENSES)
            license_state = { :state => :error,
                              :log_level => :error,
                              :log_message => "Configuration Management is not available: #{xpack_info.license_type} is not a valid license for this feature."
            }
          end
        else
          license_state = {:state => :error,
                           :log_level => :error,
                           :log_message => 'Configuration Management is not available: License information is currently unavailable. Please make sure you have added your production elasticsearch connection info in the xpack.management.elasticsearch settings.'
          }
        end
        license_state
      end

      alias_method :enabled?, :match?

      private
      def pipeline_ids
        @settings.get("xpack.management.pipeline.id")
      end

      def client
        @client ||= build_client
      end
    end
  end
end
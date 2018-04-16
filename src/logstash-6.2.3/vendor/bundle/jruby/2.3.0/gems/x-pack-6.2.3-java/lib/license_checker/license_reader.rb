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
# from Elasticsearchod_missing Incorporated.
#
require 'logstash/logging/logger'
require 'logstash/outputs/elasticsearch'
require 'logstash/json'
require 'json'

module LogStash
  module LicenseChecker
    class LicenseReader
      include LogStash::Util::Loggable

      def initialize(settings, feature, options)
        @namespace = "xpack.#{feature}"
        @settings = settings
        @es_options = options
      end

      # # This is a bit of a hack until we refactor the ElasticSearch plugins
      # # and extract correctly the http client, right now I am using the plugins
      # # to deal with the certificates and the other SSL options
      # #
      # # But we have to silence the logger from the plugin, to make sure the
      # # log originate from the `ElasticsearchSource`
      def build_client
        es = LogStash::Outputs::ElasticSearch.new(@es_options)
        new_logger = logger
        es.instance_eval { @logger = new_logger }
        es.build_client
      end

      def fetch_license
        client.get(license_path)
      end

      def xpack_installed?
        begin
          !not_found?(client.get(xpack_path))
        rescue ::LogStash::Outputs::ElasticSearch::HttpClient::Pool::BadResponseCodeError => e
          raise e unless e.response_code == 404
          false
        end
      end

      # ES client does not raise a BadResponseError in the event a 404, or return a response code.
      # It _does_ however embed the status code in the response.
      def not_found?(response)
        !!response['status'] && response['status'] == 404
      end

      def license_path
        '_xpack/license'
      end

      def xpack_path
        '_xpack'
      end

      def client
        @client ||= build_client
      end
    end
  end
end

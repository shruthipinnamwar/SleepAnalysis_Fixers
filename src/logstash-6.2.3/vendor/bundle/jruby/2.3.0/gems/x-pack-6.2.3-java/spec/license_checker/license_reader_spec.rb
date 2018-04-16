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
require "spec_helper"
require "logstash/json"
require "license_checker/license_reader"
require "monitoring/monitoring"
require "stud/temporary"


describe LogStash::LicenseChecker::LicenseReader do
  let(:elasticsearch_url) { ["https://localhost:9898"] }
  let(:elasticsearch_username) { "elastictest" }
  let(:elasticsearch_password) { "testchangeme" }
  let(:extension) { LogStash::MonitoringExtension.new }
  let(:system_settings) { LogStash::SETTINGS.clone }

  let(:settings) do
    {
      "xpack.monitoring.enabled" => true,
      "xpack.monitoring.elasticsearch.url" => elasticsearch_url,
      "xpack.monitoring.elasticsearch.username" => elasticsearch_username,
      "xpack.monitoring.elasticsearch.password" => elasticsearch_password,
    }
  end

  before do
    extension.additionals_settings(system_settings)
    apply_settings(settings, system_settings)
  end

  subject { described_class.new(system_settings, 'monitoring') }

  describe ".new" do
    context "when password isn't set" do
      let(:settings) do
        {
          "xpack.monitoring.enabled" => true,
          "xpack.monitoring.elasticsearch.url" => elasticsearch_url,
          "xpack.monitoring.elasticsearch.username" => elasticsearch_username,
          # "xpack.monitoring.elasticsearch.password" => elasticsearch_password,
        }
      end
      it "should raise an ArgumentError" do
        expect { described_class.new(system_settings, 'xpack.monitoring') }.to raise_error(ArgumentError)
      end
    end
  end
end

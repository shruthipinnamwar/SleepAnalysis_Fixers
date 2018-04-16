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
require "logstash/environment"
require "logstash/settings"
require "logstash/util/time_value"
require "logstash/plugins/hooks_registry"
require "config_management/extension"
require "config_management/hooks"

describe LogStash::ConfigManagement::Extension do
  let(:extension) { described_class.new }

  describe "#register_hook" do
    subject(:hooks) { LogStash::Plugins::HooksRegistry.new }
    before { extension.register_hooks(hooks) }

    it "register hooks on `LogStash::Runner`" do
      expect(hooks).to have_registered_hook(LogStash::Runner, LogStash::ConfigManagement::Hooks)
    end
  end

  describe "#additionals_settings" do
    subject(:settings) { LogStash::SETTINGS.clone }

    before { extension.additionals_settings(settings) }

    describe "#additionals_settings" do
      define_settings(
        "xpack.management.enabled" => [LogStash::Setting::Boolean, false],
        "xpack.management.logstash.poll_interval" => [LogStash::Setting::TimeValue, 5000000000],
        "xpack.management.pipeline.id" => [LogStash::Setting::ArrayCoercible, ["main"]],
        "xpack.management.elasticsearch.url" => [LogStash::Setting::ArrayCoercible, ["https://localhost:9200"]],
        "xpack.management.elasticsearch.username" => [LogStash::Setting::String, "logstash_system"],
        "xpack.management.elasticsearch.password" => [LogStash::Setting::String, nil],
        "xpack.management.elasticsearch.ssl.ca" => [LogStash::Setting::NullableString, nil],
        "xpack.management.elasticsearch.ssl.truststore.path" => [LogStash::Setting::NullableString, nil],
        "xpack.management.elasticsearch.ssl.truststore.password" => [LogStash::Setting::NullableString, nil],
        "xpack.management.elasticsearch.ssl.keystore.path" => [LogStash::Setting::NullableString, nil],
        "xpack.management.elasticsearch.ssl.keystore.password" => [LogStash::Setting::NullableString, nil]
      )
    end
  end
end

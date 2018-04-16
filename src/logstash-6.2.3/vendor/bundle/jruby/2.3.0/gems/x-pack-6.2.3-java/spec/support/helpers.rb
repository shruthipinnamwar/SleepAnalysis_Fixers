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
#
# Settings' TimeValue is using nanos seconds as the default unit
def time_value(time)
  LogStash::Util::TimeValue.from_value(time).to_nanos
end

# Allow to easily asserts the configuration created
# by the `#additionals_settings` callback
def define_settings(settings_options)
  settings_options.each do |name, options|
    klass, expected_default_value = options

    it "define setting: `#{name} of type: `#{klass}` with a default value of `#{expected_default_value}`" do
      expect { settings.get_setting(name) }.not_to raise_error
      expect(settings.get_setting(name)).to be_kind_of(klass)
      expect(settings.get_default(name)).to eq(expected_default_value)
    end
  end
end


def apply_settings(settings_values, settings = nil)
  settings = settings.nil? ? LogStash::SETTINGS.clone : settings

  settings_values.each do |key, value|
    settings.set(key, value)
  end

  settings
end

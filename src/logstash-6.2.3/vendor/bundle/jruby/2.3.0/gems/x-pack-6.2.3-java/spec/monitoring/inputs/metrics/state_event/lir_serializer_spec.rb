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

describe ::LogStash::Inputs::Metrics::StateEvent::LIRSerializer do
  let(:config) do
    <<-EOC
      input { fake_input {} }
      filter { 
        if ([foo] > 2) {
          fake_filter {} 
        }
      }
      output { fake_output {} }
    EOC
  end
  let(:config_source_with_metadata) do
    [org.logstash.common.SourceWithMetadata.new("string", "spec", config)]
  end

  let(:lir_pipeline) do
    ::LogStash::Compiler.compile_sources(config_source_with_metadata, LogStash::SETTINGS)
  end

  describe "#serialize" do
    it "should serialize cleanly" do
      expect do
        described_class.serialize(lir_pipeline)
      end.not_to raise_error
    end
  end
end

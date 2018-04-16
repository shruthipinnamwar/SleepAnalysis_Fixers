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
module LogStash; module Inputs; class Metrics;
  class StateEventFactory
    require "monitoring/inputs/metrics/state_event/lir_serializer"
    def initialize(pipeline)
      raise ArgumentError, "No pipeline passed in!" unless pipeline.is_a?(LogStash::Pipeline) || pipeline.is_a?(LogStash::JavaBasePipeline)
      @event = LogStash::Event.new
      
      @event.set("[@metadata]", {
        "document_type" => "logstash_state",
        "timestamp" => Time.now
      })
      
      @event.set("[pipeline]", pipeline_data(pipeline))
      
      @event.remove("@timestamp")
      @event.remove("@version")      

      @event
    end

    def pipeline_data(pipeline)
      {
        "id" => pipeline.pipeline_id,
        "hash" => pipeline.lir.unique_hash,
        "ephemeral_id" => pipeline.ephemeral_id,
        "workers" =>  pipeline.settings.get("pipeline.workers"),
        "batch_size" =>  pipeline.settings.get("pipeline.batch.size"),
        "representation" => ::LogStash::Inputs::Metrics::StateEvent::LIRSerializer.serialize(pipeline.lir)
      }
    end

    def make
      @event
    end
  end
end; end; end

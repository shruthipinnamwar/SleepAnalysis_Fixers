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
module LogStash; module Inputs; class Metrics; module StatsEvent;
  class PipelinesInfo
    def self.format_pipelines_info(agent, metric_store, extended_performance_collection)
      # It is important that we iterate via the agent's pipelines vs. the
      # metrics pipelines. This prevents race conditions as pipeline stats may be
      # populated before the agent has it in its own pipelines state
      agent.with_pipelines do |pipelines|
        stats = metric_store.get_with_path("/stats/pipelines")[:stats][:pipelines]
        pipelines.map do |pipeline_id, pipeline|
          p_stats = stats[pipeline_id]
          # Don't record stats for system pipelines
          next nil if pipeline.system?
          res = {
            "id" => pipeline_id.to_s,
            "hash" => pipeline.lir.unique_hash,
            "ephemeral_id" => pipeline.ephemeral_id,
            "events" => format_pipeline_events(p_stats[:events]),
            "queue" => format_queue_stats(pipeline_id, metric_store),
            "reloads" => {
              "successes" => p_stats[:reloads][:successes].value,
              "failures" => p_stats[:reloads][:failures].value
            }
          }
          
          if extended_performance_collection
            res["vertices"] = format_pipeline_vertex_stats(p_stats[:plugins], pipeline)
          end
          
          res
        end.compact
      end
    end

    def self.format_pipeline_events(stats)
      result = {}
      (stats || {}).each { |stage, counter| result[stage.to_s] = counter.value }
      result
    end

    def self.format_pipeline_vertex_stats(stats, pipeline)
      return nil unless stats
      
      [:inputs, :filters, :outputs].flat_map do |section|
        format_pipeline_vertex_section_stats(stats[section], pipeline)
      end.select {|stats| !stats.nil?} # Ignore empty sections
    end

    ROOT_METRIC_MAPPINGS = {
      'events.in' => 'events_in',
      'events.out' => 'events_out',
      'events.queue_push_duration_in_millis' => 'queue_push_duration_in_millis',
      'events.duration_in_millis' => 'duration_in_millis',
      'name' => :discard # we don't need this, pipeline_state has this already
    }

    def self.format_pipeline_vertex_section_stats(stats, pipeline)
      return nil unless stats
      
       (stats || {}).reduce([]) do |acc,kv|
        plugin_id, plugin_stats = kv
        
        props = Hash.new {|h,k| h[k] = []}
        next unless plugin_stats
        
        flattened = flatten_metrics(plugin_stats)

        segmented = flattened.reduce(Hash.new {|h,k| h[k] = []}) do |acc,kv|
          k,v = kv
          metric_value = v.value
          root_metric_field = ROOT_METRIC_MAPPINGS[k]

          if root_metric_field
            if root_metric_field != :discard
              acc[root_metric_field] = metric_value
            end
          else
            type_sym = v.type.to_sym

            nested_type = if type_sym == :"counter/long"
                            :long_counters
                          elsif type_sym == :"gauge/numeric"
                            :double_gauges
                          else
                            nil
                          end

            if nested_type
              acc[nested_type] << { :name => k, :value => metric_value }
            end
         end

          acc
        end
        
        acc << {
          :id => plugin_id,
          :pipeline_ephemeral_id => pipeline.ephemeral_id
        }.merge(segmented)
        acc
      end
    end

    def self.flatten_metrics(hash_or_value, namespaces = [])
      if hash_or_value.is_a?(Hash)
        return hash_or_value.reduce({}) do |acc,kv| 
          k,v = kv
          # We must concat the arrays, creating a copy instead of mutation
          # to handle the case where there are multiple sibling metrics in a namespace
          new_namespaces = namespaces.clone
          new_namespaces << k
          acc.merge(flatten_metrics(v, new_namespaces))
        end
      else
        { namespaces.join('.') => hash_or_value }
      end
    end

    def self.format_queue_stats(pipeline_id, metric_store)
      path = [:stats, :pipelines, pipeline_id, :queue, :type]
      if metric_store.has_metric?(*path)
        queue_type = metric_store.get_shallow(*path).value
      else
        queue_type = 'memory'
      end
      events = 0
      if queue_type == "persisted"
        events = metric_store.get_shallow(:stats, :pipelines, pipeline_id, :queue, :events).value
      end
      {:type => queue_type, :events_count => events}
    end
  end
end; end; end; end

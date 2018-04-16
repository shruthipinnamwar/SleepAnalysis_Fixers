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
require "logstash/util/loggable"
require "concurrent"

module LogStash module Inputs
  class TimerTaskLogger
    include LogStash::Util::Loggable

    def update(run_at, result, exception)
      if !exception.nil?
        # This can happen if the pipeline is blocked for too long
        if exception.is_a?(Concurrent::TimeoutError)
          logger.debug("metric shipper took too much time to complete", :exception => exception.class, :message => exception.message)
        else
          logger.error("metric shipper exception", :exception => exception.class, :message => exception.message)
        end
      end
    end
  end
end end

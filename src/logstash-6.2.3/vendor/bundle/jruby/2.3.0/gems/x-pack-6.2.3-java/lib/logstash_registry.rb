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
require "logstash/plugins/registry"
require "logstash/modules/util"
require "monitoring/monitoring"
require "monitoring/inputs/metrics"
require "config_management/extension"

LogStash::PLUGIN_REGISTRY.add(:input, "metrics", LogStash::Inputs::Metrics)
LogStash::PLUGIN_REGISTRY.add(:universal, "monitoring", LogStash::MonitoringExtension)
LogStash::PLUGIN_REGISTRY.add(:universal, "config_management", LogStash::ConfigManagement::Extension)

root_dir = File.expand_path(File.join("..", ".."), __FILE__)
LogStash::Modules::Util.register_local_modules(root_dir)

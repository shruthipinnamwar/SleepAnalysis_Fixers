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
RSpec::Matchers.define :have_registered_hook do |emitter_scope, klass|
  match do |hooks|
    hooks.registered_hook?(emitter_scope, klass)
  end

  failure_message do
    "HooksRegistry doesn't contains a hook named `#{klass}` for the specified emitter scope: `#{emitter_scope}`"
  end
end

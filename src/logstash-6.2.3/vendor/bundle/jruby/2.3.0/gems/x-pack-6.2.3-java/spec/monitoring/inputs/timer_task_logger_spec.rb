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
require "monitoring/inputs/timer_task_logger"

describe LogStash::Inputs::TimerTaskLogger do
  subject { described_class.new }

  context "#update" do
    let(:run_at) { Time.now }
    let(:result) { :dummy_result }

    context "when there is no exception" do
      it "succesfully run" do
        expect { subject.update(run_at, result, nil) }.not_to raise_error
      end
    end

    context "when there is an exception" do
      context "Concurrent::TimeoutError" do
        let(:exception) { Concurrent::TimeoutError.new }

        it "logs the exception in debug mode" do
          expect(subject.logger).to receive(:debug).with(/metric shipper/, hash_including(:exception => exception.class, :message => exception.message ))
          subject.update(run_at, result, exception)
        end
      end

      context "Any other exception" do
        let(:exception) { ArgumentError.new }

        it "logs the exception in debug mode" do
          expect(subject.logger).to receive(:error).with(/metric shipper/, hash_including(:exception => exception.class, :message => exception.message ))
          subject.update(run_at, result, exception)
        end
      end
    end
  end
end

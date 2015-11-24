# encoding: utf-8
require 'spec_helper'
require "logstash/filters/example"

describe LogStash::Filters::Example do
  describe "Set to Hello World" do
    let(:config) do <<-CONFIG
      filter {
        example {
          key_regex => '(\\w+).(\\w+).(.+).mean$'
          key_regex_fields => ["", "cluster", "host"]
        }
      }
    CONFIG
    end

    sample("qps.forseti.192.168.11.11.mean" => "70") do
      expect(subject).to include("metrics")
      expect(subject['metrics'][0]['qps']).to eq('70')
      expect(subject['metrics'][0]['cluster']).to eq('forseti')
      expect(subject['metrics'][0]['host']).to eq('192.168.11.11')

    end
  end
end

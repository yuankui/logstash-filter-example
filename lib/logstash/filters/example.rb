# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This example filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::Example < LogStash::Filters::Base
  config_name "example"

  config :key_regex, :validate => :string, :required => true

  config :key_regex_fields, :validate => :array, :required => true

  def register
    @key_regex = Regexp.new(@key_regex)

    if not @key_regex_fields.one? { |x| x == ''}
      raise 'key_regex_fields should contain one nil element'
    end
  end

  def filter(event)
    metrics = []
    event.to_hash.each_pair do |k, v|
      elements = @key_regex.match(k)
      next if elements == nil

      # remove the first: the whole string
      elements = elements.to_a
      elements.slice!(0)
      next if elements.size != @key_regex_fields.size

      data_map = {}
      @key_regex_fields.each_with_index do
        |x,i|
        e = elements[i]
        if x == ''
          field_name = e
          data_map[field_name] = v
        else
          field_name = @key_regex_fields[i]
          data_map[field_name] = e
        end
      end
      metrics.push data_map
    end

    event['metrics'] = metrics

  end
end # class LogStash::Filters::Example

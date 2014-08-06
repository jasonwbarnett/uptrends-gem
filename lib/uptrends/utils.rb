require 'json'
require 'active_support/inflector'

module Uptrends
  class Utils
    def self.gen_request_body(object)
      new_hash = object.original_hash.inject({}) do |memo,(k,v)|
        if k == 'Guid'
          memo
        else
          memo[k] = object.send(k.underscore)
          memo
        end
      end

      request_body = JSON.dump(new_hash)
    end

    def self.to_s(object)
      string = []
      object.attributes.each do |attr|
        string << "#{attr}: #{object.send(attr)}"
      end

      "#{string.join("\n")}"
    end

    # This method sets up all of our attr_accessor so we can easily edit probe attributes
    def self.gen_and_set_accessors(object)
      attributes = []
      object.original_hash.each_pair do |k,v|

        k = k.underscore
        case k
        when "guid"
          object.class.send(:attr_reader, k)
          object.instance_variable_set("@#{k}", v)
        else
          object.class.send(:attr_accessor, k)
          object.send("#{k}=", v)
        end
        attributes << k

      end
      object.instance_variable_set(:@attributes, attributes)
    end

  end
end

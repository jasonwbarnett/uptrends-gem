require 'json'
require 'active_support/inflector'

module Uptrends
  class Utils
    def self.gen_request_body(object)
      new_hash = object.original_hash.inject({}) do |memo,(k,v)|
        if k.to_s.underscore == 'guid'
          memo
        else
          memo[k.to_s.camelize] = object.send(k.to_s.underscore)
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

        k = k.to_s.underscore
        case k
        when "guid"
          # setup attr_reader for guid and set it's value.
          object.class.send(:attr_reader, k)
          object.instance_variable_set("@#{k}", v)
        else
          # setup a attr_accessor for all other attributes
          object.class.send(:attr_accessor, k)
          object.send("#{k}=", v)
        end
        attributes << k.to_sym

      end
      object.instance_variable_set(:@attributes, attributes)
    end

  end
end

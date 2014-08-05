require 'json'

module Uptrends
  class Utils
    def self.gen_request_body(object)
      new_hash = object.original_keys.inject({}) do |memo,key|
        if key == 'Guid'
          memo
        else
          memo[key] = object.send(key.downcase.to_sym)
          memo
        end
      end

      request_body = JSON.dump(new_hash)
    end

    def self.to_s(object)
      string = []
      object.original_keys.each do |key|
        string << "#{key}: #{object.send(key.downcase.to_sym)}"
      end

      "#{string.join("\n")}"
    end

    # This method sets up all of our attr_accessor so we can easily edit probe attributes
    def self.gen_and_set_accessors(object)
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

      end
    end

  end
end

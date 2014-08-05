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
  end
end

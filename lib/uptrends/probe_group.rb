require 'json'

module Uptrends
  class ProbeGroup
    attr_reader   :original_hash, :original_keys, :attributes

    attr_reader   :guid, :isall, :isclientprobegroup
    attr_accessor :name

    def initialize(probe_group_hash = {})
      @original_hash     = probe_group_hash
      @original_keys     = probe_group_hash.keys
      @attributes        = probe_group_hash.keys.map{|x| x.downcase.to_sym }

      @guid               = probe_group_hash["Guid"] ? probe_group_hash["Guid"] : nil
      @name               = probe_group_hash["Name"]
      @isall              = probe_group_hash["IsAll"]
      @isclientprobegroup = probe_group_hash["IsClientProbeGroup"]
    end

    def gen_request_body
      new_hash = original_keys.inject({}) do |memo,key|
        if key == 'Guid'
          memo
        else
          memo[key] = self.send(key.downcase.to_sym)
          memo
        end
      end

      request_body = JSON.dump(new_hash)
    end

    def to_s
      string = []
      original_keys.each do |key|
        string << "#{key}: #{self.send(key.downcase.to_sym)}"
      end

      "#{string.join("\n")}"
    end

  end
end

require 'json'
require 'uptrends/utils'

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

    def to_s
      Uptrends::Utils.to_s(self)
    end

  end
end

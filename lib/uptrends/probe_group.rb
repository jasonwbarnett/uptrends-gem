require 'json'
require 'uptrends/utils'

module Uptrends
  class ProbeGroup

    attr_reader   :original_hash, :original_keys, :attributes

    def initialize(probe_group_hash = {})
      @original_hash     = probe_group_hash
      @original_keys     = probe_group_hash.keys
      @attributes        = probe_group_hash.keys.map{|x| x.downcase.to_sym }

      Uptrends::Utils.gen_and_set_accessors(self)
    end

    def to_s
      Uptrends::Utils.to_s(self)
    end

  end
end

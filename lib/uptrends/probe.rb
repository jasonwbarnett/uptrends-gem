require 'json'
require 'uptrends/utils'
require 'active_support/inflector'

module Uptrends
  class Probe
    attr_reader   :original_hash, :original_keys, :attributes

    def initialize(probe_hash = {})
      @original_hash     = probe_hash
      @original_keys     = probe_hash.keys
      @attributes        = probe_hash.keys.map{|x| x.downcase.to_sym }

      Uptrends::Utils.gen_and_set_accessors(self)
    end

    def to_s
      Uptrends::Utils.to_s(self)
    end

  end
end

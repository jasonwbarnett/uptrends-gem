require 'json'
require 'uptrends/utils'

module Uptrends
  class ProbeGroup

    attr_reader :original_hash, :attributes

    def initialize(probe_group_hash = {})
      @original_hash     = probe_group_hash

      Uptrends::Utils.gen_and_set_accessors(self)
    end

    def to_s
      Uptrends::Utils.to_s(self)
    end

  end
end

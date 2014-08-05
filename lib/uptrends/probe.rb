require 'json'
require 'uptrends/utils'

module Uptrends
  class Probe

    attr_reader :original_hash, :attributes

    def initialize(probe_hash = {})
      @original_hash = probe_hash

      Uptrends::Utils.gen_and_set_accessors(self)
    end

    def to_s
      Uptrends::Utils.to_s(self)
    end

  end
end

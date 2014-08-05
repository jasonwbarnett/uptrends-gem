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

      gen_and_set_accessors(probe_hash)
    end

    def to_s
      Uptrends::Utils.to_s(self)
    end

    private
      # This method sets up all of our attr_accessor so we can easily edit probe attributes
      def gen_and_set_accessors(hash)
        hash.each_pair do |k,v|

          k = k.underscore
          case k
          when "guid"
            puts "entering guid"
            self.class.send(:attr_reader, k)
            instance_variable_set("@#{k}", v)
          else
            self.class.send(:attr_accessor, k)
            self.send("#{k}=", v)
          end

        end
      end

  end
end

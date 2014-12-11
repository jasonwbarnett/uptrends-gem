require 'uptrends/base'

module Uptrends
  class Checkpoint < Base

    def initialize(client, response, attributes = {})
      @attributes = attributes
      gen_and_set_accessors
    end

    undef_method :create!
    undef_method :update!
    undef_method :delete!

    private
    def api_url
      "/checkpointservers"
    end

    def gen_and_set_accessors
      attributes = []
      self.attributes.each_pair do |k,v|

        k = k.to_s.underscore
        # setup attr_reader for all attributes and set it's value.
        self.class.send(:attr_reader, k)
        self.instance_variable_set("@#{k}", v)

        attributes << k.to_sym
      end

      @attributes = attributes
    end

  end
end

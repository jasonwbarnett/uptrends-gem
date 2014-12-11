require 'uptrends/base'

module Uptrends
  class Probe < Base
    def self.parse(client, response)
      probes = super
      if Array === probes
        probes.map do |probe|
          new(client, response, probe)
        end
      else
        probe = probes
        new(client, response, probe)
      end
    end
  end
end

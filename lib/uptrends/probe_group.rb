require 'uptrends/base'

module Uptrends
  class ProbeGroup < Base
    def self.parse(client, response)
      probe_groups = super
      if Array === probe_groups
        probe_groups.map do |probe_group|
          new(client, response, probe_group)
        end
      else
        probe_group = probe_groups
        new(client, response, probe_group)
      end
    end

    def api_url
      "/probegroups"
    end
  end
end

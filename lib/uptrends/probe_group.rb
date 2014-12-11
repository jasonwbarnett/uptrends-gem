require 'uptrends/base'

module Uptrends
  class ProbeGroup < Base

    def add_probe(probe)
      fail("You must pass an Uptrends::Probe")           unless Uptrends::Probe === probe
      fail("The probe you passed does not have a guid.") unless probe.attributes.include?(:guid)
      fail("This group does not have a guid.")           unless self.attributes.include?(:guid)

      body = JSON.dump({"ProbeGuid" => probe.guid})
      response = @client.class.post("#{api_url}/#{@guid}/members", body: body)
      self.class.check_error!(response)
    end

    def members
      fail("This group does not have a guid.")           unless self.attributes.include?(:guid)

      response = @client.class.get("#{api_url}/#{@guid}/members")
      self.class.check_error!(response)
      Uptrends::Probe.parse(self, response)
    end

    private
    def api_url
      "/probegroups"
    end

  end
end

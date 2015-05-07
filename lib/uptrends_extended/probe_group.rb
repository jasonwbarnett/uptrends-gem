require 'uptrends_extended/base'

module UptrendsExtended
  class ProbeGroup < Base

    def add_probe(probe)
      probe_operation(probe, :post)
    end

    def remove_probe(probe)
      probe_operation(probe, :delete)
    end

    def members
      fail('This group does not have a guid.')           unless self.attributes.include?(:guid)

      response = @client.class.get("#{api_url}/#{@guid}/members")
      self.class.check_error!(response)
      UptrendsExtended::Probe.parse(self, response)
    end

    private
    def api_url
      '/probegroups'
    end

    def probe_operation(probe, method)
      fail('You must pass an UptrendsExtended::Probe')           unless UptrendsExtended::Probe === probe
      fail('The probe you passed does not have a guid.') unless probe.attributes.include?(:guid)
      fail('This group does not have a guid.')           unless self.attributes.include?(:guid)

      body = JSON.dump({'ProbeGuid' => probe.guid})
      response = @client.class.send(method, "#{api_url}/#{@guid}/members", body: body)
      self.class.check_error!(response)

      parsed_response = response.parsed_response
      if parsed_response.nil?
        parsed_response
      else
        group_guid = parsed_response['Guid']
        probe_guid = parsed_response['ProbeGuid']

        [ @client.probe_group(group_guid), @client.probe(probe_guid) ]
      end
    end

  end
end

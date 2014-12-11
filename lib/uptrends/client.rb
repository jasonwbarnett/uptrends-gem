require "httparty"
require "uptrends/probe"
require "uptrends/probe_group"
require "uptrends/checkpoint"
require "uptrends/utils"
require "uptrends/api_error"

module Uptrends
  class Client
    include HTTParty
    format :json
    base_uri('https://api.uptrends.com/v3')

    attr_reader :username

    def initialize(opts = {})
      @username = opts[:username] ? opts[:username] : fail("You must specify the :username option")
      password  = opts[:password] ? opts[:password] : fail("You must specify the :password option")

      # This makes it so that every request uses basic auth
      self.class.basic_auth(@username, password)
      # This makes it so that every request uses ?format=json
      self.class.default_params({format: 'json'})
      # This makes it so that every request uses ?format=json
      self.class.headers({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    def probes(opts = {})
      get_probes
    end

    def checkpoints(opts = {})
      if opts[:refresh]
        @checkpoints = get_checkpoints
      else
        @checkpoints ||= get_checkpoints
      end
    end

    def probe_groups
      @probe_groups ||= get_probe_groups
    end

    def get_probe_group_members(opts = {})
      group = opts[:group]
      fail("You must pass a probe group using group: option.") unless Uptrends::ProbeGroup === group
      group_guid = opts[:group].guid ? opts[:group].guid : fail("The probe group you passed does not have a guid.")

      res = self.class.get("/probegroups/#{group_guid}/members")
      parsed_response = raise_or_return(res)
      probe_group_members = parsed_response.inject([]) do |memo, x|
        memo << Uptrends::Probe.new(x)
        memo
      end
    end

    def add_probe(opts = {})
      probe = Uptrends::Probe.new(opts)
      res  = self.class.post("/probes", body: Uptrends::Utils.gen_request_body(probe))
      parsed_response = raise_or_return(res)
      new_probe = Uptrends::Probe.new(parsed_response)

      probes << new_probe

      new_probe
    end

    def add_probe_to_group(opts = {})
      probe = opts[:probe]
      group = opts[:group]

      fail("You must pass a probe and probe group using probe: and group: opts.") unless Uptrends::Probe === probe && Uptrends::ProbeGroup === group

      probe_guid = opts[:probe].guid ? opts[:probe].guid : fail("The probe you passed does not have a guid.")
      group_guid = opts[:group].guid ? opts[:group].guid : fail("The probe group you passed does not have a guid.")


      post_body = JSON.dump({"ProbeGuid" => probe_guid})
      res = self.class.post("/probegroups/#{group_guid}/members", body: post_body)
      raise_or_return(res)
    end

    def update_probe(probe)
      res = self.class.put("/probes/#{probe.guid}", body: Uptrends::Utils.gen_request_body(probe))
      raise_or_return(res)
    end

    def delete_probe(probe)
      res = self.class.delete("/probes/#{probe.guid}")
      raise_or_return(res)

      probes.delete_if { |x| x.guid == probe.guid }
    end

    def create_http_probe(opts = {})
      name            = opts[:name]            ? opts[:name]            : fail("You must provide a name!")
      url             = opts[:url]             ? opts[:url]             : fail("You must provide a URL!")
      check_frequency = opts[:check_frequency] ? opts[:check_frequency] : 15
      match_pattern   = opts[:match_pattern]

      probe     = Uptrends::Probe.new(gen_new_probe_hash(name, url, check_frequency, match_pattern))
      res  = self.class.post("/probes", body: Uptrends::Utils.gen_request_body(probe))
      parsed_response = raise_or_return(res)
      new_probe = Uptrends::Probe.new(parsed_response)

      probes << new_probe

      new_probe
    end

    private
    def get_probes
      get_all(Uptrends::Probe)
    end

    def get_checkpoints
      get_all(Uptrends::Checkpoint)
    end

    def get_probe_groups
      get_all(Uptrends::ProbeGroup)
    end

    def get_all(type)
      if type == Uptrends::ProbeGroup
        uri = '/probegroups'
      elsif type == Uptrends::Probe
        uri = '/probes'
      elsif type == Uptrends::Checkpoint
        uri = '/checkpointservers'
      else
        fail("You passed an unknown type. Try Uptrends::Probe, Uptrends::ProbeGroup or Uptrends::Checkpoint")
      end

      res = self.class.get(uri)

      type.parse(self, res)
    end

    def gen_new_probe_hash(name, url, check_frequency = 15, match_pattern = nil)
      base_hash = {"Name"=>"", "URL"=>"", "CheckFrequency"=>check_frequency, "IsActive"=>true, "GenerateAlert"=>true, "Notes"=>"", "PerformanceLimit1"=>60000, "PerformanceLimit2"=>60000, "ErrorOnLimit1"=>false, "ErrorOnLimit2"=>false, "MinBytes"=>0, "ErrorOnMinBytes"=>false, "Timeout"=>30000, "TcpConnectTimeout"=>10000, "MatchPattern"=>"", "DnsLookupMode"=>"Local", "UserAgent"=>"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1;)", "UserName"=>"", "Password"=>"", "IsCompetitor"=>false, "Checkpoints"=>"", "HttpMethod"=>"Get", "PostData"=>""}

      if url =~ %r{^https:}i
        base_hash.merge!({"Name"=>name, "URL"=>url, "ProbeType"=>"Https", "Port"=>443})
      elsif url =~ %r{^http:}i
        base_hash.merge!({"Name"=>name, "URL"=>url, "ProbeType"=>"Http", "Port"=>80})
      else
        fail("The URL you provided didn't start with http or https!")
      end

      base_hash.merge!({"MatchPattern"=>match_pattern}) unless match_pattern.nil?

      base_hash
    end

    def raise_or_return(result)
      response_code = result.response.code.to_i
      case response_code
        when 200...300
          result.parsed_response
        else
          raise Uptrends::ApiError.new(result.parsed_response)
      end
    end

  end
end

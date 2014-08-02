require "httparty"
require "uptrends/probe"
require "uptrends/probe_group"

module Uptrends
  class ApiClient
    include HTTParty
    format :json
    base_uri('https://api.uptrends.com/v3')

    attr_reader :username

    def initialize(options = {})
      @username = options[:username] ? options[:username] : fail("You must specify the :username option")
      password  = options[:password] ? options[:password] : fail("You must specify the :password option")

      # This makes it so that every request uses basic auth
      self.class.basic_auth(@username, password)
      # This makes it so that every request uses ?format=json
      self.class.default_params({format: 'json'})
      # This makes it so that every request uses ?format=json
      self.class.headers({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    def probes
      @_probes ||= get_probes
    end

    def probe_groups
      @_probe_groups ||= get_probe_groups
    end

    private
    def get_probes
      parsed_response = self.class.get('/probes').parsed_response
      probes = parsed_response.inject([]) do |memo, x|
        memo << Uptrends::Probe.new(x)
        memo
      end
    end

    def get_probe_groups
      parsed_response = self.class.get('/probegroups').parsed_response
      probe_groups = parsed_response.inject([]) do |memo, x|
        memo << Uptrends::ProbeGroup.new(x)
        memo
      end
    end

    public
    def get_probe_group_members(options = {})
      group = options[:group]
      fail("You must pass a probe group using group: option.") unless Uptrends::ProbeGroup === group
      group_guid = options[:group].guid ? options[:group].guid : fail("The probe group you passed does not have a guid.")

      parsed_response = self.class.get("/probegroups/#{group_guid}/members").parsed_response
      probe_group_members = parsed_response.inject([]) do |memo, x|
        memo << Uptrends::Probe.new(x)
        memo
      end
    end

    def add_probe_to_group(options = {})
      probe = options[:probe]
      group = options[:group]

      fail("You must pass a probe and probe group using probe: and group: options.") unless Uptrends::Probe === probe && Uptrends::ProbeGroup === group

      probe_guid = options[:probe].guid ? options[:probe].guid : fail("The probe you passed does not have a guid.")
      group_guid = options[:group].guid ? options[:group].guid : fail("The probe group you passed does not have a guid.")


      post_body = JSON.dump({"ProbeGuid" => probe_guid})
      self.class.post("/probegroups/#{group_guid}/members", body: post_body)
    end

    def update_probe(probe)
      self.class.put("/probes/#{probe.guid}", body: probe.gen_request_body)
    end

    def delete_probe(probe)
      self.class.delete("/probes/#{probe.guid}")

      @probes ||= get_probes
      @probes.delete_if { |x| x.guid == probe.guid }
    end

    def create_http_probe(options = {}) #url, match_pattern = nil)
      base_hash = {"Name"=>"", "URL"=>"", "CheckFrequency"=>5, "IsActive"=>true, "GenerateAlert"=>true, "Notes"=>"", "PerformanceLimit1"=>60000, "PerformanceLimit2"=>60000, "ErrorOnLimit1"=>false, "ErrorOnLimit2"=>false, "MinBytes"=>0, "ErrorOnMinBytes"=>false, "Timeout"=>30000, "TcpConnectTimeout"=>10000, "MatchPattern"=>"", "DnsLookupMode"=>"Local", "UserAgent"=>"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1;)", "UserName"=>"", "Password"=>"", "IsCompetitor"=>false, "Checkpoints"=>"", "HttpMethod"=>"Get", "PostData"=>""}

      name          = options[:name]          ? options[:name]          : fail("You must provide a name!")
      url           = options[:url]           ? options[:url]           : fail("You must provide a URL!")
      match_pattern = options[:match_pattern] ? options[:match_pattern] : nil

      if url =~ %r{^https:}i
        base_hash.merge!({"Name"=>name, "URL"=>url, "ProbeType"=>"Https", "Port"=>443})
      elsif url =~ %r{^http:}i
        base_hash.merge!({"Name"=>name, "URL"=>url, "ProbeType"=>"Http", "Port"=>80})
      else
        fail("The URL you provided didn't start with http or https!")
      end

      base_hash.merge!({"MatchPattern"=>match_pattern}) unless match_pattern.nil?

      p = Uptrends::Probe.new(base_hash)
      response = self.class.post("/probes", body: p.gen_request_body)
      new_probe = Uptrends::Probe.new(response.parsed_response)

      @probes ||= get_probes
      @probes << new_probe
    end


  end
end

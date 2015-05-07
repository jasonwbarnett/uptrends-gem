require 'httparty'
require 'uptrends_extended/probe'
require 'uptrends_extended/probe_group'
require 'uptrends_extended/checkpoint'

module UptrendsExtended
  class Client
    include HTTParty
    format :json
    base_uri('https://api.uptrends.com/v3')

    attr_reader :username

    def initialize(opts = {})
      @username = opts[:username] ? opts[:username] : fail('You must specify the :username option')
      password  = opts[:password] ? opts[:password] : fail('You must specify the :password option')

      # This makes it so that every request uses basic auth
      self.class.basic_auth(@username, password)
      # This makes it so that every request uses ?format=json
      self.class.default_params({format: 'json'})
      # This makes it so that every request uses ?format=json
      self.class.headers({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    def probe(guid)
      get(UptrendsExtended::Probe, guid: guid)
    end

    def probe_group(guid)
      get(UptrendsExtended::ProbeGroup, guid: guid)
    end

    def probes
      get(UptrendsExtended::Probe, all: true)
    end

    def checkpoints
      get(UptrendsExtended::Checkpoint, all: true)
    end

    def probe_groups
      get(UptrendsExtended::ProbeGroup, all: true)
    end

    def add_probe(opts = {})
      p = UptrendsExtended::Probe.new(self, nil, opts)
      p.create!
    end

    def add_probe_group(opts = {})
      pg = UptrendsExtended::ProbeGroup.new(self, nil, opts)
      pg.create!
    end

    private
    def get(type, opts = {})
      all  = opts[:all]  ? opts[:all]  : false
      guid = opts[:guid] ? opts[:guid] : nil

      if type == UptrendsExtended::Probe
        uri = '/probes'
      elsif type == UptrendsExtended::ProbeGroup
        uri = '/probegroups'
      elsif type == UptrendsExtended::Checkpoint
        uri = '/checkpointservers'
      else
        fail('You passed an unknown type. Try UptrendsExtended::Probe, UptrendsExtended::ProbeGroup or UptrendsExtended::Checkpoint')
      end

      if all
        response = self.class.get(uri)
      elsif guid
        response = self.class.get("#{uri}/#{guid}")
      end

      type.parse(self, response)
    end

  end
end


require "httparty"
require "uptrends/probe"
require "uptrends/probe_group"
require "uptrends/checkpoint"

module Uptrends
  class Client
    include HTTParty
    format :json
    base_uri('https://api.uptrends.com/v3')

    attr_reader :username, :debug

    def initialize(opts = {})
      @username = opts[:username] ? opts[:username] : fail("You must specify the :username option")
      password  = opts[:password] ? opts[:password] : fail("You must specify the :password option")
      @debug    = opts[:debug]

      # This makes it so that every request uses basic auth
      self.class.basic_auth(@username, password)
      # This makes it so that every request uses ?format=json
      self.class.default_params({format: 'json'})
      # This makes it so that every request uses ?format=json
      self.class.headers({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    def probe(guid)
      get(Uptrends::Probe, guid: guid)
    end

    def probe_group(guid)
      get(Uptrends::ProbeGroup, guid: guid)
    end

    def probes
      get(Uptrends::Probe, all: true)
    end

    def checkpoints
      get(Uptrends::Checkpoint, all: true)
    end

    def probe_groups
      get(Uptrends::ProbeGroup, all: true)
    end

    def add_probe(opts = {})
      p = Uptrends::Probe.new(self, nil, opts)
      p.create!
    end

    def add_probe_group(opts = {})
      pg = Uptrends::ProbeGroup.new(self, nil, opts)
      pg.create!
    end

    private
    def get(type, opts = {})
      all  = opts[:all]  ? opts[:all]  : false
      guid = opts[:guid] ? opts[:guid] : nil

      if type == Uptrends::Probe
        uri = '/probes'
      elsif type == Uptrends::ProbeGroup
        uri = '/probegroups'
      elsif type == Uptrends::Checkpoint
        uri = '/checkpointservers'
      else
        fail("You passed an unknown type. Try Uptrends::Probe, Uptrends::ProbeGroup or Uptrends::Checkpoint")
      end

      if all
        res = self.class.get(uri)
      elsif guid
        res = self.class.get("#{uri}/#{guid}")
      end

      type.parse(self, res)
    end

  end
end


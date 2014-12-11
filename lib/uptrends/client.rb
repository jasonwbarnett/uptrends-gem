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

    def probes
      get_all(Uptrends::Probe)
    end

    def checkpoints
      get_all(Uptrends::Checkpoint)
    end

    def probe_groups
      get_all(Uptrends::ProbeGroup)
    end

    def add_probe(opts = {})
      probe = Uptrends::Probe.new(self, nil, opts)
      probe.create!
    end

    private
    def get_all(type)
      if type == Uptrends::Probe
        uri = '/probes'
      elsif type == Uptrends::ProbeGroup
        uri = '/probegroups'
      elsif type == Uptrends::Checkpoint
        uri = '/checkpointservers'
      else
        fail("You passed an unknown type. Try Uptrends::Probe, Uptrends::ProbeGroup or Uptrends::Checkpoint")
      end

      res = self.class.get(uri)

      type.parse(self, res)
    end

  end
end


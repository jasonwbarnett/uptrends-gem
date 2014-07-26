require "httparty"
require "uptrends/probe"

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
      @probes ||= get_probes
    end

    def get_probes
      parsed_response = self.class.get('/probes').parsed_response
      @probes = parsed_response.inject([]) do |memo, x|
        memo << Uptrends::Probe.new(x)
        memo
      end
    end

    def update_probe(probe)
      self.class.put("/probes/#{probe.guid}", body: probe.gen_request_body)
    end
  end
end

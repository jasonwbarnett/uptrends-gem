require "httparty"

module Uptrends
  class ApiClient
    include HTTParty
    format :json
    base_uri 'https://api.uptrends.com/v3'

    attr_reader :username

    def initialize(options = {})
      @username = options[:username] ? options[:username] : fail("You must specify a username.")
      @password = options[:password] ? options[:password] : fail("You must specify a password.")
    end
  end
end

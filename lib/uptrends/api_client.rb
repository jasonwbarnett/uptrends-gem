require "httparty"

module Uptrends
  class ApiClient
    include HTTParty
    format :json
    base_uri 'https://api.uptrends.com/v3'

    attr_reader :username

    def initialize(options = {})
      @username = options[:username] ? options[:username] : fail("You must specify the :username option")
      @password = options[:password] ? options[:password] : fail("You must specify the :password option")
    end
  end
end

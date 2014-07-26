require_relative '../spec_helper'

describe Uptrends::ApiClient do
  it "must be an instance of Uptrends::ApiClient" do
    Uptrends::ApiClient.new(username: 'myUsername', password: 'MyP@ss').must_be_instance_of Uptrends::ApiClient
  end

  describe "Initializing with a username and password is required" do
    it "should raise RuntimeError when username is not provided." do
      proc { Uptrends::ApiClient.new(password: 'MyP@ss') }.must_raise RuntimeError
    end

    it "should raise excepetion when password is not provided." do
      proc { Uptrends::ApiClient.new(username: 'myUsername') }.must_raise RuntimeError
    end
  end

  describe "default attributes" do
    it "must include httparty methods" do
      Uptrends::ApiClient.must_include HTTParty
    end

    it "must have the base url set to the Uptrends API endpoint" do
      Uptrends::ApiClient.base_uri.must_equal 'https://api.uptrends.com/v3'
    end

    it "must have the format set to json" do
      Uptrends::ApiClient.format.must_equal :json
    end
  end

  describe "querying Uptrends" do
    before(:each) do
      @uptrends = Uptrends::ApiClient.new(username: ENV['uptrends_username'], password: ENV['uptrends_password'])
    end

    describe "GET Probes" do
      before do
        VCR.insert_cassette('GET Probes')
      end

      after do
        VCR.eject_cassette
      end

      it "makes a GET request for all probes" do
        puts "my call"
      end
    end
  end
end

require_relative '../spec_helper'

describe Uptrends::ApiClient do
  describe "Initializing with a username and password is required" do
    it "should raise RuntimeError when username is not provided." do
      proc { Uptrends::ApiClient.new(password: 'MyP@ss') }.must_raise RuntimeError
    end

    it "should raise excepetion when password is not provided." do
      proc { Uptrends::ApiClient.new(username: 'myUsername') }.must_raise RuntimeError
    end
  end

  it "must be an instance of Uptrends::ApiClient" do
    Uptrends::ApiClient.new(username: 'myUsername', password: 'MyP@ss').must_be_instance_of Uptrends::ApiClient
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

  #describe "GET Probes" do
  #  before do
  #    VCR.use_cassette('GET Probes') do
  #      @uptrends.
  #    end
  #  end
  #end
end

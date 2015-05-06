require_relative '../spec_helper'

describe Uptrends::Client do
  let(:username) { ENV['UPTRENDS_USERNAME'] }
  let(:password) { ENV['UPTRENDS_PASSWORD'] }

  describe 'Setting up testing' do
    it 'should have a username defined in an env varible: UPTRENDS_USERNAME' do
      username.wont_be_nil
    end

    it 'should have a password defined in an env varible: UPTRENDS_PASSWORD' do
      password.wont_be_nil
    end
  end

  it 'must be an instance of Uptrends::Client' do
    Uptrends::Client.new(username: username, password: password).must_be_instance_of Uptrends::Client
  end

  describe 'Initializing with a username and password is required' do
    it 'should raise RuntimeError when username is not provided.' do
      proc { Uptrends::Client.new(password: password) }.must_raise RuntimeError
    end

    it 'should raise RuntimeError when password is not provided.' do
      proc { Uptrends::Client.new(username: username) }.must_raise RuntimeError
    end
  end

  describe 'default attributes' do
    it 'must include httparty methods' do
      Uptrends::Client.must_include HTTParty
    end

    it 'must have the base url set to the Uptrends API endpoint' do
      Uptrends::Client.base_uri.must_equal 'https://api.uptrends.com/v3'
    end

    it 'must have the format set to json' do
      Uptrends::Client.format.must_equal :json
    end
  end

  describe 'When initializing a new Uptrends::Client with a username and password' do
    let(:uc) { Uptrends::Client.new(username: username, password: password) }

    it 'auth[:username] should match the username provided' do
      uc.class.default_options[:basic_auth][:username].must_equal username
    end

    it 'auth[:password] should match the password provided' do
      uc.class.default_options[:basic_auth][:password].must_equal password
    end

    it 'default_params[:format] should be set to json' do
      uc.class.default_params[:format].must_equal 'json'
    end

    it 'headers should be set to application/json' do
      uc.class.headers.must_equal({'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end
  end

  describe 'After Uptrends::Client is initialized' do
    let(:uc) { Uptrends::Client.new(username: username, password: password) }

    it 'should have a #username method' do
      uc.must_respond_to :username
    end

    it 'should have a #probe method' do
      uc.must_respond_to :probe
    end

    it 'should have a #probe_group method' do
      uc.must_respond_to :probe_group
    end

    it 'should have a #probes method' do
      uc.must_respond_to :probes
    end

    it 'should have a #checkpoints method' do
      uc.must_respond_to :checkpoints
    end

    it 'should have a #probe_groups method' do
      uc.must_respond_to :probe_groups
    end

    it 'should have a #add_probe method' do
      uc.must_respond_to :add_probe
    end

    it 'should have a #add_probe_group method' do
      uc.must_respond_to :add_probe_group
    end
  end

  describe 'Querying Uptrends' do
    let(:uc) { Uptrends::Client.new(username: username, password: password) }

    describe '#probe' do
      before do
        VCR.insert_cassette('GET Probe', :record => :new_episodes, match_requests_on: [:method, :body, :headers, :query, :path])
        #Did you mean one of :method, :uri, :body, :headers, :host, :path, :query, :body_as_json?
      end

      after do
        VCR.eject_cassette
      end

      it 'should return a single Uptrends::Probe object' do
        probe = uc.probe('bbfc88d4-8f71-1234-ae02-00c7f479cc90')
        probe.class.must_equal Uptrends::Probe
      end
    end

    describe '#probes' do
      before do
        VCR.insert_cassette('GET Probes', :record => :new_episodes, match_requests_on: [:method, :body, :headers, :query, :path])
        #Did you mean one of :method, :uri, :body, :headers, :host, :path, :query, :body_as_json?
      end

      after do
        VCR.eject_cassette
      end

      it 'should return an array of Uptrends::Probe objects' do
        probes = uc.probes
        probes.each do |probe|
          probe.class.must_equal Uptrends::Probe
        end
      end
    end

    describe '#probe_group' do
      before do
        VCR.insert_cassette('GET Probe Group', :record => :new_episodes, match_requests_on: [:method, :body, :headers, :query, :path])
        #Did you mean one of :method, :uri, :body, :headers, :host, :path, :query, :body_as_json?
      end

      after do
        VCR.eject_cassette
      end

      it 'should return a single Uptrends::ProbeGroup object' do
        probe = uc.probe_group('819ddc84-a4f2-1234-a046-4e40559fde07')
        probe.class.must_equal Uptrends::ProbeGroup
      end
    end

    describe '#probe_groups' do
      before do
        VCR.insert_cassette('GET Probe Groups', :record => :new_episodes, match_requests_on: [:method, :body, :headers, :query, :path])
        #Did you mean one of :method, :uri, :body, :headers, :host, :path, :query, :body_as_json?
      end

      after do
        VCR.eject_cassette
      end

      it 'should return an array of Uptrends::ProbeGroup objects' do
        probe_groups = uc.probe_groups
        probe_groups.each do |probe_group|
          probe_group.class.must_equal Uptrends::ProbeGroup
        end
      end
    end

    describe '#checkpoints' do
      before do
        VCR.insert_cassette('GET Checkpoints', :record => :new_episodes, match_requests_on: [:method, :body, :headers, :query, :path])
        #Did you mean one of :method, :uri, :body, :headers, :host, :path, :query, :body_as_json?
      end

      after do
        VCR.eject_cassette
      end

      it 'should return an array of Uptrends::Checkpoint objects' do
        checkpoints = uc.checkpoints
        checkpoints.each do |checkpoint|
          checkpoint.class.must_equal Uptrends::Checkpoint
        end
      end
    end

  end
end

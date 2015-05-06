require_relative '../spec_helper'

describe Uptrends::Probe do
  let(:username) { ENV['UPTRENDS_USERNAME'] }
  let(:password) { ENV['UPTRENDS_PASSWORD'] }
  let(:uc) { Uptrends::Client.new(username: username, password: password) }
  let(:up) { Uptrends::Probe.new(uc, nil, {'Guid' => 'myguid', 'HelloYou' => 'myvalue', 'other' => 'thing'}) }

  it '#guid' do
    up.must_respond_to :guid
    up.guid.must_equal 'myguid'
  end

  it '#guid= must NOT exist' do
    up.wont_respond_to :guid=
  end

  it '#hello_you' do
    up.must_respond_to :hello_you
    up.hello_you.must_equal 'myvalue'
  end

  it '#hello_you=' do
    up.must_respond_to :hello_you=
    up.hello_you = 'updates to hello_you='
    up.hello_you.must_equal 'updates to hello_you='
  end

  it '#other' do
    up.must_respond_to :other
    up.other.must_equal 'thing'
  end

  it '#other=' do
    up.must_respond_to :other=
    up.other = 'updates to other'
    up.other.must_equal 'updates to other'
  end

  it '#to_s' do
    up.to_s.must_equal "guid: myguid\nhello_you: myvalue\nother: thing"
  end

  it '#api_url (private)' do
    up.send(:api_url).must_equal '/probes'
  end
end

require_relative '../spec_helper'

describe Uptrends::ProbeGroup do
  let(:username) { ENV['UPTRENDS_USERNAME'] }
  let(:password) { ENV['UPTRENDS_PASSWORD'] }
  let(:uc) { Uptrends::Client.new(username: username, password: password) }
  let(:up) { Uptrends::ProbeGroup.new(uc, nil, {'Guid' => 'myguid', 'Name' => 'myvalue', 'other' => 'thing'}) }

  it '#guid' do
    up.must_respond_to :guid
    up.guid.must_equal 'myguid'
  end

  it '#guid= must NOT exist' do
    up.wont_respond_to :guid=
  end

  it '#name' do
    up.must_respond_to :name
    up.name.must_equal 'myvalue'
  end

  it '#name=' do
    up.must_respond_to :name=
    up.name = 'updates to hello_you='
    up.name.must_equal 'updates to hello_you='
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
    up.to_s.must_equal "guid: myguid\nname: myvalue\nother: thing"
  end
end

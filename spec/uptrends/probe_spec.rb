require_relative '../spec_helper'

describe Uptrends::Probe do
  let(:up) { Uptrends::Probe.new({"Guid" => "myguid", "HelloYou" => "myvalue", "other" => "thing"}) }

    it "#guid" do
      up.must_respond_to :guid
      up.guid.must_equal "myguid"
    end

    it "#guid= must NOT exist" do
      up.wont_respond_to :guid=
    end

    it "#hello_you" do
      up.must_respond_to :hello_you
      up.hello_you.must_equal "myvalue"
    end

    it "#hello_you=" do
      up.must_respond_to :hello_you=
      up.hello_you = "updates to hello_you="
      up.hello_you.must_equal "updates to hello_you="
    end

    it "#other" do
      up.must_respond_to :other
      up.other.must_equal "thing"
    end

    it "#other=" do
      up.must_respond_to :other=
      up.other = "updates to other"
      up.other.must_equal "updates to other"
    end

end

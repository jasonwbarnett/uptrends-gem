require_relative '../spec_helper'

describe Uptrends::Probe do
  let(:up) { Uptrends::Probe.new }
  %w[guid name url port checkfrequency probetype isactive generatealert notes performancelimit1 performancelimit2 erroronlimit1 erroronlimit2 minbytes erroronminbytes timeout tcpconnecttimeout matchpattern dnslookupmode useragent username password iscompetitor checkpoints httpmethod postdata].each do |attr|
    it "should have a ##{attr} reader" do
      up.send(attr.to_sym)
    end
  end

  %w[name url port checkfrequency probetype isactive generatealert notes performancelimit1 performancelimit2 erroronlimit1 erroronlimit2 minbytes erroronminbytes timeout tcpconnecttimeout matchpattern dnslookupmode useragent username password iscompetitor checkpoints httpmethod postdata].each do |attr|
    it "should have a ##{attr} writer" do
      up.send("#{attr}=", "some_value")
    end
  end
end

require 'json'

module Uptrends
  class Probe
    attr_reader   :guid, :original_hash, :original_keys, :attributes
    attr_accessor :name, :url, :port, :checkfrequency, :probetype, :isactive, :generatealert, :notes, :performancelimit1, :performancelimit2, :erroronlimit1, :erroronlimit2, :minbytes, :erroronminbytes, :timeout, :tcpconnecttimeout, :matchpattern, :dnslookupmode, :useragent, :username, :password, :iscompetitor, :checkpoints, :httpmethod, :postdata

    def initialize(probe_hash = {})
      @original_hash     = probe_hash
      @original_keys     = probe_hash.keys
      @attributes        = probe_hash.keys.map{|x| x.downcase.to_sym }

      @guid              = probe_hash["Guid"]
      @name              = probe_hash["Name"]
      @url               = probe_hash["URL"]
      @port              = probe_hash["Port"]
      @checkfrequency    = probe_hash["CheckFrequency"]
      @probetype         = probe_hash["ProbeType"]
      @isactive          = probe_hash["IsActive"]
      @generatealert     = probe_hash["GenerateAlert"]
      @notes             = probe_hash["Notes"]
      @performancelimit1 = probe_hash["PerformanceLimit1"]
      @performancelimit2 = probe_hash["PerformanceLimit2"]
      @erroronlimit1     = probe_hash["ErrorOnLimit1"]
      @erroronlimit2     = probe_hash["ErrorOnLimit2"]
      @minbytes          = probe_hash["MinBytes"]
      @erroronminbytes   = probe_hash["ErrorOnMinBytes"]
      @timeout           = probe_hash["Timeout"]
      @tcpconnecttimeout = probe_hash["TcpConnectTimeout"]
      @matchpattern      = probe_hash["MatchPattern"]
      @dnslookupmode     = probe_hash["DnsLookupMode"]
      @useragent         = probe_hash["UserAgent"]
      @username          = probe_hash["UserName"]
      @password          = probe_hash["Password"]
      @iscompetitor      = probe_hash["IsCompetitor"]
      @checkpoints       = probe_hash["Checkpoints"]

      if probetype == "Http"
        @httpmethod = probe_hash["HttpMethod"]
        @postdata   = probe_hash["PostData"]
      end
    end

    alias :probetype= :probetype=
    alias :type :probetype

    def gen_request_body
      new_hash = original_keys.inject({}) do |memo,key|
        if key == 'Guid'
          memo
        else
          memo[key] = self.send(key.downcase.to_sym)
          memo
        end
      end

      request_body = JSON.dump(new_hash)
    end

    def to_s
      string = []
      original_keys.each do |key|
        string << "#{key}: #{self.send(key.downcase.to_sym)}"
      end

      "#{string.join("\n")}"
    end

  end
end

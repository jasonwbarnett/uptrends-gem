require 'json'

module Uptrends
  class Probe
    attr_reader   :guid, :original_hash, :original_keys, :attributes
    attr_accessor :name, :url, :port, :checkfrequency, :probetype, :isactive, :generatealert, :notes, :performancelimit1, :performancelimit2, :erroronlimit1, :erroronlimit2, :minbytes, :erroronminbytes, :timeout, :tcpconnecttimeout, :matchpattern, :dnslookupmode, :useragent, :username, :password, :iscompetitor, :checkpoints, :httpmethod, :postdata

    def initialize(probe_hash = {})
      @original_hash     = probe_hash
      @original_keys     = probe_hash.keys
      @attributes        = probe_hash.keys.map{|x| x.downcase.to_sym }

      @guid              = probe_hash["Guid"]              ? probe_hash["Guid"]              : nil
      @name              = probe_hash["Name"]              ? probe_hash["Name"]              : nil
      @url               = probe_hash["URL"]               ? probe_hash["URL"]               : nil
      @port              = probe_hash["Port"]              ? probe_hash["Port"]              : nil
      @checkfrequency    = probe_hash["CheckFrequency"]    ? probe_hash["CheckFrequency"]    : nil
      @probetype         = probe_hash["ProbeType"]         ? probe_hash["ProbeType"]         : nil
      @isactive          = probe_hash["IsActive"]          ? probe_hash["IsActive"]          : nil
      @generatealert     = probe_hash["GenerateAlert"]     ? probe_hash["GenerateAlert"]     : nil
      @notes             = probe_hash["Notes"]             ? probe_hash["Notes"]             : nil
      @performancelimit1 = probe_hash["PerformanceLimit1"] ? probe_hash["PerformanceLimit1"] : nil
      @performancelimit2 = probe_hash["PerformanceLimit2"] ? probe_hash["PerformanceLimit2"] : nil
      @erroronlimit1     = probe_hash["ErrorOnLimit1"]     ? probe_hash["ErrorOnLimit1"]     : nil
      @erroronlimit2     = probe_hash["ErrorOnLimit2"]     ? probe_hash["ErrorOnLimit2"]     : nil
      @minbytes          = probe_hash["MinBytes"]          ? probe_hash["MinBytes"]          : nil
      @erroronminbytes   = probe_hash["ErrorOnMinBytes"]   ? probe_hash["ErrorOnMinBytes"]   : nil
      @timeout           = probe_hash["Timeout"]           ? probe_hash["Timeout"]           : nil
      @tcpconnecttimeout = probe_hash["TcpConnectTimeout"] ? probe_hash["TcpConnectTimeout"] : nil
      @matchpattern      = probe_hash["MatchPattern"]      ? probe_hash["MatchPattern"]      : nil
      @dnslookupmode     = probe_hash["DnsLookupMode"]     ? probe_hash["DnsLookupMode"]     : nil
      @useragent         = probe_hash["UserAgent"]         ? probe_hash["UserAgent"]         : nil
      @username          = probe_hash["UserName"]          ? probe_hash["UserName"]          : nil
      @password          = probe_hash["Password"]          ? probe_hash["Password"]          : nil
      @iscompetitor      = probe_hash["IsCompetitor"]      ? probe_hash["IsCompetitor"]      : nil
      @checkpoints       = probe_hash["Checkpoints"]       ? probe_hash["Checkpoints"]       : nil

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

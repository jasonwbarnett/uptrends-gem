require 'uptrends/base'

module Uptrends
  class Probe < Base

    private
    def api_url
      "/probes"
    end

  end
end

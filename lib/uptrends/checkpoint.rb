require 'uptrends/base'

module Uptrends
  class Checkpoint < Base

    def api_url
      "/checkpointservers"
    end

    undef_method :create!
    undef_method :update!
    undef_method :delete!

  end
end

require 'uptrends/base'

module Uptrends
  class Checkpoint < Base

    undef_method :create!
    undef_method :update!
    undef_method :delete!

    private
    def api_url
      "/checkpointservers"
    end

  end
end

require 'uptrends/base'

module Uptrends
  class Checkpoint < Base
    def self.parse(client, response)
      checkpoints = super
      if Array === checkpoints
        checkpoints.map do |checkpoint|
          new(client, response, checkpoint)
        end
      else
        checkpoint = checkpoints
        new(client, response, checkpoint)
      end
    end

    def api_url
      "/checkpointservers"
    end
  end
end

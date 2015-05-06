require 'uptrends/base'

module Uptrends
  class Probe < Base

    def enable
      self.is_active = true
      self.update!
    end

    def disable
      self.is_active = false
      self.update!
    end

    def enable_alerts
      self.generate_alert = true
      self.update!
    end

    def disable_alerts
      self.generate_alert = false
      self.update!
    end

    private
    def api_url
      '/probes'
    end

  end
end

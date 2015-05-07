require 'uptrends_extended/api_error'
require 'json'
require 'active_support/inflector'

module UptrendsExtended
  class Base

    attr_reader :attributes

    def initialize(client, response, attributes = {})
      @client     = client
      @attributes = attributes
      gen_and_set_accessors
    end

    def create!
      response = @client.class.post(api_url, body: gen_request_body)
      self.class.parse(@client, response)
    end

    def update!
      response = @client.class.put("#{api_url}/#{@guid}", body: gen_request_body)
      self.class.check_error!(response)
    end

    def delete!
      response = @client.class.delete("#{api_url}/#{@guid}")
      self.class.check_error!(response)
    end

    def self.check_error!(response)
      response_code = response.response.code.to_i
      case response_code
        when 200...300
          response.parsed_response
        else
          raise UptrendsExtended::ApiError.new(response.parsed_response)
      end
    end

    # @param [yyyy/mm/dd] start_of_period
    # @param [yyyy/mm/dd] end_of_period
    # @param [Day, Week, Month, Year, ProbeGroup, Probe, Checkpoint, ErrorCode, ErrorLevel] dimension
    def statistics(start_of_period, end_of_period, dimension)
      response = @client.class.get("#{api_url}/#{@guid}/statistics?Start=#{start_of_period}&End=#{end_of_period}&Dimension=#{dimension}", body: gen_request_body)
      self.class.check_error!(response)
    end

    def self.parse(client, response)
      check_error!(response)
      parsed_response = response.parsed_response
      if Array === parsed_response
        parsed_response.map do |item|
          new(client, response, item)
        end
      else
        new(client, response, parsed_response)
      end
    end

    def to_s
      string = []
      attributes.each do |attr|
        string << "#{attr}: #{self.send(attr)}"
      end

      "#{string.join("\n")}"
    end

    private

    # This method sets up all of our attr_accessor so we can easily edit probe attributes
    def gen_and_set_accessors
      attributes = []
      self.attributes.each_pair do |k,v|

        k = k.to_s.underscore
        case k
        when 'guid'
          # setup attr_reader for guid and set it's value.
          self.class.send(:attr_reader, k)
          self.instance_variable_set("@#{k}", v)
        else
          # setup a attr_accessor for all other attributes
          self.class.send(:attr_accessor, k)
          self.send("#{k}=", v)
        end
        attributes << k.to_sym

      end

      @attributes = attributes
    end

    def gen_request_body
      new_hash = @attributes.inject({}) do |memo,(k,v)|
        if k.to_s.underscore == 'guid'
          memo
        else
          memo[k.to_s.camelize] = self.send(k.to_s.underscore)
          memo
        end
      end

      request_body = JSON.dump(new_hash)
    end

  end
end


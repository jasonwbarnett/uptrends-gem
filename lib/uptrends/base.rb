require "uptrends/api_error"
require "json"

module Uptrends
  class Base

    attr_reader :attributes, :url

    def initialize(client, response, attributes = {})
      @client     = client
      @attributes = attributes
      gen_and_set_accessors
    end

    #def method_missing(name, *args, &block)
    #  @attributes[name] or super
    #end

    def respond_to?(name)
      super(name) || @attributes.key?(name)
    end

    def create!
      @client.class.post(url, body: gen_request_body)
    end

    def update!
      @client.class.put(url, body: gen_request_body)
    end

    def self.check_error!(response)
      response_code = response.response.code.to_i
      case response_code
        when 200...300
          response.parsed_response
        else
          raise Uptrends::ApiError.new(response.parsed_response)
      end
    end

    def self.parse(client, response)
      check_error!(response)
      response.parsed_response
    end

    # This method sets up all of our attr_accessor so we can easily edit probe attributes
    def gen_and_set_accessors
      attributes = []
      self.attributes.each_pair do |k,v|

        k = k.to_s.underscore
        case k
        when "guid"
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


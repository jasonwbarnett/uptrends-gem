require_relative '../lib/uptrends'
require_relative '../lib/uptrends/api_client'
require_relative '../lib/uptrends/probe'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

# VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

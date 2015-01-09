require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require_relative '../lib/uptrends'
require_relative '../lib/uptrends/api_error'
require_relative '../lib/uptrends/base'
require_relative '../lib/uptrends/checkpoint'
require_relative '../lib/uptrends/client'
require_relative '../lib/uptrends/probe'
require_relative '../lib/uptrends/probe_group'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'vcr'

# VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
end

@username = ENV['UPTRENDS_USERNAME']
@password = ENV['UPTRENDS_PASSWORD']

if @username.nil? || @password.nil?
  $stderr.puts "You must define UPTRENDS_USERNAME and UPTRENDS_PASSWORD as environment variables, exiting..."
  exit 1
end

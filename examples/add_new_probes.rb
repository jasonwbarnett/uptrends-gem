#!/usr/bin/env ruby
require 'uptrends/api_client'
require 'uri'
require 'rack'

def parse_uri_for_db(url)
  begin
    uri = URI(url)
    Rack::Utils.parse_query(uri.query)['dbname']
  rescue URI::InvalidURIError
    return nil
  end
end

def parse_uri(url)
  begin
    uri = URI(url)
    "#{uri.scheme}://#{uri.host}"
  rescue URI::InvalidURIError
    return nil
  end
end

(puts "You must set both the \"UPTRENDS_USERNAME\" and \"UPTRENDS_PASSWORD\" environment variables, exiting..."; exit 1;) unless ENV['UPTRENDS_USERNAME'] && ENV['UPTRENDS_PASSWORD']

u = Uptrends::ApiClient.new(username: ENV['UPTRENDS_USERNAME'], password: ENV['UPTRENDS_PASSWORD'])

filename  = ARGV.first
site_urls = File.open(filename)
site_urls = site_urls.readlines.map { |x| x.delete("\n") }.compact

# Build array of URLs to possibly add to Uptrends
uri_array = site_urls.map do |url|
  uri = parse_uri(url)
  db  = parse_uri_for_db(url)
  next unless uri && db
  [uri, db]
end.compact

# Build array of Uptrends Probe URLs that already exist
probe_uri_array = u.probes.map do |x|
  next unless x.probe_type =~ /Https?/
  parse_uri(x.url)
end.compact

# select our probe group that we want to also add our probes too
linux_probe_group = u.probe_groups.select { |x| x.name =~ /Linux/}.first

uri_array.each do |uri|
  url = "#{uri[0]}/User/Login"
  db  = uri[1]
  next if url =~ /\.xxx/i || url =~ /staging/i || url =~ /qa(languages)?[0-9gaspb]+(prod)?\./i
  next if probe_uri_array.include?(url)

  puts "Adding a \"#{url}\" probe"
  new_probe = u.create_http_probe(name: db, url: url, match_pattern: 'j_username')

  puts "Adding \"#{url}\" to the \"#{linux_probe_group.name}\" group now... "
  u.add_probe_to_group(probe: new_probe, group: linux_probe_group)
end


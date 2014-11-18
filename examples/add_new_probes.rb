#!/usr/bin/env ruby
require 'uptrends/client'
require 'uri'
require 'rack'

def parse_uri_for_db(url)
  begin
    uri = URI(url)
    Rack::Utils.parse_query(uri.query)['dbname'].downcase
  rescue URI::InvalidURIError
    return nil
  end
end

def parse_uri(url)
  begin
    uri = URI(url)
    "#{uri.scheme}://#{uri.host}".downcase
  rescue URI::InvalidURIError
    return nil
  end
end

(puts "You must set both the \"UPTRENDS_USERNAME\" and \"UPTRENDS_PASSWORD\" environment variables, exiting..."; exit 1;) unless ENV['UPTRENDS_USERNAME'] && ENV['UPTRENDS_PASSWORD']

u = Uptrends::Client.new(username: ENV['UPTRENDS_USERNAME'], password: ENV['UPTRENDS_PASSWORD'])

filename  = ARGV.first
site_urls = File.open(filename)
site_urls = site_urls.readlines.map { |x| x.delete("\n") }.compact

# Build array of URLs to possibly add to Uptrends
uri_array = site_urls.map do |url|
  uri = parse_uri(url)
  db  = parse_uri_for_db(url)
  next unless uri && db
  [uri, db]
end.compact.uniq

# Build array of Uptrends Probe URLs that already exist
probe_uri_array = u.probes.map do |x|
  next unless x.probe_type =~ /Https?/
  parse_uri(x.url)
end.compact

uri_array.each do |uri|
  url = uri[0]
  db  = uri[1]

  # If URL contains certain things we don't want to add it Uptrends
  next if url =~ /\.xxx/i         ||
          url =~ /backup/i        ||
          url =~ /clusterbogota/i ||
          url =~ /archive/i       ||
          url =~ /thebigawards/i  ||
          url =~ /staging/i       ||
          url =~ /qa(languages)?[0-9gaspb]+(prod)?\./i
  # If the URL already exists at Uptrends we don't want to add it again!
  next if probe_uri_array.include?(url)

  url = "#{uri[0]}/User/Login"
  db  = uri[1]

  puts "Adding a \"#{url}\" probe"
  begin
    new_probe = u.create_http_probe(name: db, url: url, match_pattern: 'j_username')
  rescue Uptrends::ApiError => e
    puts e.message
  end
end


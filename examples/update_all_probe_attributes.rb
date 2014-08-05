#!/usr/bin/env ruby
require 'uptrends/api_client'

(puts "You must set both the \"UPTRENDS_USERNAME\" and \"UPTRENDS_PASSWORD\" environment variables, exiting..."; exit 1;) unless ENV['UPTRENDS_USERNAME'] && ENV['UPTRENDS_PASSWORD']

u = Uptrends::ApiClient.new(username: ENV['UPTRENDS_USERNAME'], password: ENV['UPTRENDS_PASSWORD'])

u.probes.each do |x|
  next if x.dnslookupmode == 'Local' && x.timeout == 20000 && x.tcpconnecttimeout == 5000

  x.dnslookupmode = 'Local'
  x.timeout = 20000
  x.tcpconnecttimeout = 5000

  puts "Updating the \"#{x.name}\" probe now... "
  u.update_probe(x)
end

#!/usr/bin/env ruby
require 'uptrends/api_client'

(puts "You must set both the \"uptrends_username\" and \"uptrends_password\" environment variables, exiting..."; exit 1;) unless ENV['uptrends_username'] && ENV['uptrends_password']

u = Uptrends::ApiClient.new(username: ENV['uptrends_username'], password: ENV['uptrends_password'])

u.probes.each do |x|
  next if x.dnslookupmode == 'Local' && x.timeout == 20000 && x.tcpconnecttimeout == 5000

  x.dnslookupmode = 'Local'
  x.timeout = 20000
  x.tcpconnecttimeout = 5000

  puts "Updating the \"#{x.name}\" probe now... "
  u.update_probe(x)
end

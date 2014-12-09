#!/usr/bin/env ruby
require "uptrends"
require "ipaddr"

(puts "You must set both the \"UPTRENDS_USERNAME\" and \"UPTRENDS_PASSWORD\" environment variables, exiting..."; exit 1;) unless ENV['UPTRENDS_USERNAME'] && ENV['UPTRENDS_PASSWORD']

u = Uptrends::Client.new(username: ENV['UPTRENDS_USERNAME'], password: ENV['UPTRENDS_PASSWORD'])
checkpoint_ips = u.checkpoints.inject([]) { |memo,x| memo << x.ip_address; memo }.sort_by { |x| IPAddr.new(x) }

checkpoint_ips.each do |ip|
  puts "allow #{ip};"
end

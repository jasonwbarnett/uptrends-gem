#!/usr/bin/env ruby
require 'uptrends/client'

(puts "You must set both the \"UPTRENDS_USERNAME\" and \"UPTRENDS_PASSWORD\" environment variables, exiting..."; exit 1;) unless ENV['UPTRENDS_USERNAME'] && ENV['UPTRENDS_PASSWORD']

u = Uptrends::Client.new(username: ENV['UPTRENDS_USERNAME'], password: ENV['UPTRENDS_PASSWORD'])

# select our probe group by name
linux_probe_group = u.probe_groups.select { |x| x.name =~ /Linux/}.first

# grab the current group members
linux_group_members = u.get_probe_group_members(group: linux_probe_group)

# build an array of current probe group members guid
member_guids = linux_group_members.inject([]) do |memo, x|
  memo << x.guid
  memo
end

# add any missing probes to our probe group
u.probes.each do |x|
  next if member_guids.include?(x.guid)

  puts "Adding \"#{x.name}\" to the \"#{linux_probe_group.name}\" group now... "
  u.add_probe_to_group(probe: x, group: linux_probe_group)
end

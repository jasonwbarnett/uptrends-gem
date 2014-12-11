# Uptrends RESTful API Client

[![Code Climate](https://codeclimate.com/github/jasonwbarnett/uptrends-gem/badges/gpa.svg)](https://codeclimate.com/github/jasonwbarnett/uptrends-gem) [![Test Coverage](https://codeclimate.com/github/jasonwbarnett/uptrends-gem/badges/coverage.svg)](https://codeclimate.com/github/jasonwbarnett/uptrends-gem) [![Build Status](https://travis-ci.org/jasonwbarnett/uptrends-gem.svg?branch=master)](https://travis-ci.org/jasonwbarnett/uptrends-gem)

This is a ruby wrapper around the [Uptrends API][2]. Uptrends is a monitoring service that let's you monitor Web pages, Web services, Mail servers, Database servers, DNS, SSL certificates, FTP and more.

NOTE: This is a 3rd party gem and not an official product from Uptrends.

## Installation

Add this line to your application's Gemfile:

    gem 'uptrends'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uptrends

## Usage

First initialize an instance of the API Client and then we play with it:

    require 'uptrends'
    u = Uptrends::Client.new(username: 'my@email.com', password: 'MyP@sswo0rd')
    #  => #<Uptrends::Client:0x00000101309e48 @username="my@email.com">

Query your account for all probes:

    probes = u.probes # Returns an array of probes
    #  => [#<Uptrends::Probe:0x0000010336cac8 ...>, #<Uptrends::Probe:0x0000010336cac9 ...>, ... ]

Query your account for all probe __groups__:

    probe_groups = u.probe_groups # Returns an array of probe groups
    #  => [#<Uptrends::ProbeGroup:0x000001021594f8 ...>, #<Uptrends::ProbeGroup:0x000001021592f0 ...>, ... ]

Let's select the first probe and look at it's attributes

    p = probes.first
    #  => #<Uptrends::Probe:0x0000010336cac8 ...>

    p.attributes
    #  => [:guid, :name, :url, :port, :check_frequency, :probe_type, :is_active, :generate_alert, :notes, :performance_limit1, :performance_limit2, :error_on_limit1, :error_on_limit2, :min_bytes, :error_on_min_bytes, :timeout, :tcp_connect_timeout, :match_pattern, :dns_lookup_mode, :user_agent, :user_name, :password, :is_competitor, :checkpoints, :http_method, :post_data]

    p.guid
    #  => "7ef43a1b255949f5a052444348971690"

    p.name
    #  => "My Probe's Name"

Let's select the first probe __group__ and look at it's attributes

    pg = probe_groups.first
    #  => #<Uptrends::ProbeGroup:0x000001021594f8 ...>

    pg.attributes
    #  => [:guid, :name, :is_all, :is_client_probe_group]

    pg.guid
    #  => "c8d6a0f704494c37823850f3d4fd4273"

    pg.name
    #  => "All probes"

If you wanted to update the probe, all you need to do is change as many attributes as you want and then update, e.g.

    # Let's change the name of the probe:

    p.name = "My Probe's NEW name"
    #  => "My Probe's NEW name"

    p.update!
    #  => nil

Let's add our probe to a probe group

    response = u.add_probe_to_group(probe: p, group: pg)
    response.response
    #  => #<Net::HTTPCreated 201 Created readbody=true>

## Contributing

1. Fork it ( https://github.com/jasonwbarnett/uptrends-gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


[1]: https://uptrends.com/
[2]: http://www.uptrends.com/en/support/api

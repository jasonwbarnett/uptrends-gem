# Uptrends

This is a ruby wrapper around the [Uptrends API][2].

## Installation

Add this line to your application's Gemfile:

    gem 'uptrends'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uptrends

## Usage

First initialize an instance of the API Client and then we play with it:

    require 'uptrends/api_client'
    u = Uptrends::ApiClient.new(username: 'my@email.com', password: 'MyP@sswo0rd')
    #  => #<Uptrends::ApiClient:0x00000101309e48 @username="my@email.com">

Then you can query your account for all probes:

    probes = u.probes # Returns an array of probes
    #  => [#<Uptrends::Probe:0x0000010336cac8...>, #<Uptrends::Probe:0x0000010336cac9...>, ... ]

Let's select the first one and look at it's attributes

    p = probes.first
    #  => #<Uptrends::Probe:0x0000010336cac8...>

    p.attributes
    #  => [:guid, :name, :url, :port, :checkfrequency, :probetype, :isactive, :generatealert, :notes, :performancelimit1, :performancelimit2, :erroronlimit1, :erroronlimit2, :minbytes, :erroronminbytes, :timeout, :tcpconnecttimeout, :matchpattern, :dnslookupmode, :useragent, :username, :password, :iscompetitor, :checkpoints, :httpmethod, :postdata]

    p.guid
    #  => "7ef43a1b255949f5a052444348971690"

    p.name
    #  => "My Probe's Name"

If you wanted to update the probe, all you need to do is change it's attributes and then update, e.g.

    # Let's change the name of the probe:

    p.name = "My Probe's NEW name"
    #  => "My Probe's NEW name"
    response = u.update_probe(p)
    #  => #<HTTParty::Response:0x10 parsed_response=nil, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"cache-control"=>["private"], "server"=>["Microsoft-IIS/7.5"], "x-servername"=>["OBI"], "x-aspnet-version"=>["4.0.30319"], "x-powered-by"=>["ASP.NET"], "x-server"=>["OBI"], "date"=>["Sat, 26 Jul 2014 20:21:00 GMT"], "connection"=>["close"], "content-length"=>["0"]}>
    response.response
    #  => #<Net::HTTPOK 200 OK readbody=true>

## Contributing

1. Fork it ( https://github.com/jasonwbarnett/uptrends-gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


[1]: https://uptrends.com/
[2]: http://www.uptrends.com/en/support/api

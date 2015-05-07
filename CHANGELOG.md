# UptrendsExtended Gem Changelog

## 0.7.0
- Added the statistics part, so you are able to get statistics about probes and probegroups
- Minor syntax fixes for rails 3 and up

## 0.6.0
- Completely redesigned the UptrendsExtended::Client class to make it more idiomatic.
- Completely redesigned the UptrendsExtended::Base class to make it more idiomatic.
- Added #create!, #update! and #delete! methods to UptrendsExtended::Base
- Added #enable, #disable, #enable_alerts and #disable_alerts methods to UptrendsExtended::Probe
- Added #add_probe, #remove_probe and #members methods to UptrendsExtended::ProbeGroup
- Removed UptrendsExtended::Utils class

## 0.5.0
- Added UptrendsExtended::Monitor class.
- Added UptrendsExtended::Client#monitors method to fetch all monitors.


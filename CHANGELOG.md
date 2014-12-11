# Uptrends Gem Changelog

## 0.6.0
- Completely redesigned the Uptrends::Client class to make it more idiomatic.
- Completely redesigned the Uptrends::Base class to make it more idiomatic.
- Added #create!, #update! and #delete! methods to Uptrends::Base
- Added #enable, #disable, #enable_alerts and #disable_alerts methods to Uptrends::Probe
- Added #add_probe, #remove_probe and #members methods to Uptrends::ProbeGroup
- Removed Uptrends::Utils class

## 0.5.0
- Added Uptrends::Monitor class.
- Added Uptrends::Client#monitors method to fetch all monitors.


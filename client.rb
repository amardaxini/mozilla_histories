require 'rubygems'
require 'stalker'
# Put in queue by passing job name and file path
Stalker.enqueue('history.add_mozilla_url', :file => "places.sqlite")

require 'rubygems'
require 'stalker'
require 'browsing_history'
include Stalker

job 'screen_cap.crop_image' do |args|
  ScreenCapJob.crop_image(args['file'])
  end
job 'history.add_mozilla_url' do |args|
  BrowsingHistory.add_mozilla_histories(args['file'])
end


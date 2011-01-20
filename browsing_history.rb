require 'rubygems'
require 'mongoid'
require 'sinatra'
# More info regarding connecting mongodb using mongoid Please visit
# http://mongoid.org

Mongoid.configure do |config|
  name = 'clariant_development'
  host = 'localhost'
  port = 27017
  config.master = Mongo::Connection.new.db(name)
end
class UrlVisited
  include Mongoid::Document
  field :url
  field :access_time,:type=>DateTime
end
class BrowsingHistory
  def self.add_mozilla_histories(file_path)
    # Read from mozilla sqlite file
    # More info http://www.forensicswiki.org/wiki/Mozilla_Firefox_3_History_File_Format
    results = `cat "mozilla.txt" | sqlite3 "#{file_path}"`
    histories=results.split("\n")

    # Below Commented Block is used for
    # if we have multiple user  browsing histories then
    # we dont want to add duplicate histories

#    last_browsing_access_time = UrlVisited.order_by(:access_time.desc).first.access_time rescue nil
#    if !last_browsing_access_time.nil? && !last_browsing_access_time.blank?
#      histories.each do |h|
#        res = h.split(",")
#        if (Time.parse(res.last) > last_browsing_access_time)
#          if res.length == 2
#            url = res
#          else
#            url =res[0..res.length-1].join(",")
#          end
#          UrlVisited.create(:url=>url,:access_time=>  Time.parse(res.last).to_s(:db))
#        end
#      end
#    else

    histories.each_with_index do |result,index|
      res =  result.split(",")
      if res.length == 2
        url = res[0]
      else
        url =res[0..res.length-1].join(",")
      end
      UrlVisited.create(:url=>url,:access_time=>Time.parse(res.last).to_s(:db))
    end
  end
  #end
end
get '/' do
  @histories = UrlVisited.order_by(:access_time.desc)
  erb :index
end

__END__

@@ index
<table border=2>
  <thead>
    <tr>
      <th>Url</th>
      <th>Access time</th>
    </tr>
  </thead>
  <tbody>
    <% @histories.each do |history| %>
      <tr>
        <td><%= history.url %></td>
        <td><%= history.access_time.to_s(:db) %></td>
      </tr>
    <% end  %>
  </tbody>
</table>

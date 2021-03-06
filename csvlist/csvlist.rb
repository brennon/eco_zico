require 'csv'
require 'plist'
require 'pp'

csv_file_path = File.expand_path("../seekpoints.csv", __FILE__)

array_for_plist = []

last_page = -1

CSV.foreach(csv_file_path) do |row|
  if last_page != row[0].to_i
    last_page = row[0].to_i
    array_for_plist << { "words" => [], "image" => "empty" }
  end
  array_for_plist[row[0].to_i]["words"] << {"text"=>row[2],"time"=>row[3].to_f}
end

plist_file = "#{__FILE__[0..(__FILE__.index('.')-1)]}.plist"

outfile = File.open(File.expand_path(".", plist_file), "w+") do |f|
  f.puts array_for_plist.to_plist
end
require 'csv'
require 'plist'
require 'pp'

csv_file_path = File.expand_path("../seekpoints.csv", __FILE__)

array_for_plist = []

CSV.foreach(csv_file_path) do |row|
  array_for_plist[row[0].to_i] ||= []
  array_for_plist[row[0].to_i] << {row[2]=>row[3]}
end

plist_file = "#{__FILE__[0..(__FILE__.index('.')-1)]}.plist"

outfile = File.open(File.expand_path(".", plist_file), "w+") do |f|
  f.puts array_for_plist.to_plist
end
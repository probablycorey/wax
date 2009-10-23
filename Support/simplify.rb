# This just makes it easier to write bundles in TextMate instead of with the Bundle Editor

$:.unshift "#{ENV['TM_BUNDLE_PATH']}/Support/lib"
require "#{ENV['TM_BUNDLE_PATH']}/Support/simplify/#{ARGV[0]}"

def out!(string)
  open("~/Desktop/tm-output.txt", "w") {|f| f.write string}
end
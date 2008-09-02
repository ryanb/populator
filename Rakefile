require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('populator', '0.2.3') do |p|
  p.summary        = "Mass populate an Active Record database."
  p.description    = "Mass populate an Active Record database."
  p.url            = "http://github.com/ryanb/populator"
  p.author         = 'Ryan Bates'
  p.email          = "ryan (at) railscasts (dot) com"
  p.ignore_pattern = ["script/*", "**/*.sqlite3", "tmp/*"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

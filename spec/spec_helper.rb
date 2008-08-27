require 'rubygems'
require 'spec'
require 'active_support'
require 'active_record'
require File.dirname(__FILE__) + '/../lib/populator.rb'

# setup database adapter
ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3", 
  :dbfile => File.dirname(__FILE__) + "/test.sqlite3" 
})

# load models
# there's probably a better way to handle this
require File.dirname(__FILE__) + '/models/product.rb'
CreateProducts.migrate(:up) unless Product.table_exists?

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

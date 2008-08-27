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

unless ActiveRecord::Base.connection.respond_to? :execute_with_query_record
  ActiveRecord::Base.connection.class.class_eval do
    IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/]

    def execute_with_query_record(sql, name = nil, &block)
      $queries_executed ||= []
      $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
      execute_without_query_record(sql, name, &block)
    end

    alias_method_chain :execute, :query_record
  end
end

# load models
# there's probably a better way to handle this
require File.dirname(__FILE__) + '/models/product.rb'
CreateProducts.migrate(:up) unless Product.table_exists?

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

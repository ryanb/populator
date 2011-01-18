require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'active_support/all'

adapter = ENV['POPULATOR_ADAPTER'] || 'sqlite3'
puts "Running on #{adapter}"

# setup database adapter
ActiveRecord::Base.establish_connection(
  YAML.load(File.read(File.dirname(__FILE__) + "/database.yml"))[adapter]
)

# keep track of which queries have been executed
unless ActiveRecord::Base.connection.respond_to? :record_query
  ActiveRecord::Base.connection.class.class_eval do
    IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^begin /i, /^commit /i]

    def record_query(sql)
      $queries_executed ||= []
      $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
    end

    def execute_with_query_record(*args, &block)
      record_query(args.first)
      execute_without_query_record(*args, &block)
    end
    alias_method_chain :execute, :query_record

    def execute_batch_with_query_record(*args, &block)
      record_query(args.first)
      execute_batch_without_query_record(*args, &block)
    end
    alias_method_chain :execute_batch, :query_record
  end
end

# load models
# there's probably a better way to handle this
require File.dirname(__FILE__) + '/models/category.rb'
require File.dirname(__FILE__) + '/models/product.rb'
CreateCategories.migrate(:up) unless Category.table_exists?
CreateProducts.migrate(:up) unless Product.table_exists?

RSpec.configure do |config|
  config.mock_with :mocha
end

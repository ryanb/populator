module Populator
  module Adapters
    module Mysql
      # Executes multiple SQL statements in one query when joined with ";"
      def execute_batch(sql, name = nil)
        log(sql, name) { sql.split(';').each { |q| @connection.query(q) } }
      end
    end
  end
end

class ActiveRecord::ConnectionAdapters::MysqlAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
  include Populator::Adapters::Mysql
end

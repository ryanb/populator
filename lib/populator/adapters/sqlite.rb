module Populator
  module Adapters
    module Sqlite
      # Executes multiple SQL statements in one query when joined with ";"
      def execute_batch(sql, name = nil)
        log(sql, name) do
          @connection.transaction { |db| db.execute_batch(sql) }
        end
      end

      def populate(table, columns, rows, name = nil)
        queries = []
        rows.each do |row|
          queries << "INSERT INTO #{table} #{columns} VALUES #{row}"
        end
        execute_batch(queries.join(';'), name)
      end
    end
  end
end

# TODO find a better way to load the SQLite adapter
module ActiveRecord # :nodoc: all
  module ConnectionAdapters
    class SQLiteAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      include Populator::Adapters::Sqlite
    end
  end
end

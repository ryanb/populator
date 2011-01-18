module Populator
  module Adapters
    module Oracle

      # Executes SQL statements one at a time.

      def populate(table, columns, rows, name = nil)
        rows.each do |row|
          sql = "INSERT INTO #{table} #{columns} VALUES #{row}"
          log(sql, name) do
            @connection.exec(sql)
          end
        end
      end

    end
  end
end

module ActiveRecord # :nodoc: all
  module ConnectionAdapters
    class OracleAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      include Populator::Adapters::Oracle
    end
  end
end

module Populator
  module Adapters
    module Postgresql
      def populate(table, columns, rows, name = nil)
        queries = []
        rows.each do |row|
          row.gsub!(/^\(\d{1,}/, "(DEFAULT")
          queries << "INSERT INTO #{table} #{columns} VALUES #{row}"
        end
        execute(queries.join("; "), name)
      end
    end
  end
end

module ActiveRecord # :nodoc: all
  module ConnectionAdapters
    class PostgreSQLAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
      include Populator::Adapters::Postgresql
    end
  end
end

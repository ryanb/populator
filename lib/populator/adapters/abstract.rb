module Populator
  module Adapters
    module Abstract
      # Executes multiple SQL statements in one query when joined with ";"
      def execute_batch(sql, name = nil)
        raise NotImplementedError, "execute_batch is an abstract method"
      end

      def populate(table, columns, rows, name = nil)
        execute("INSERT INTO #{table} #{columns} VALUES #{rows.join(', ')}", name)
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.class_eval do
  include Populator::Adapters::Abstract
end

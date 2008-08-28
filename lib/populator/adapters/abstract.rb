module Populator
  module Adapters
    module Abstract
      # Executes multiple SQL statements in one query when joined with ";"
      def execute_batch(sql, name = nil)
        raise NotImplementedError, "execute_batch is an abstract method"
      end
    end
  end
end

class ActiveRecord::ConnectionAdapters::AbstractAdapter
  include Populator::Adapters::Abstract
end

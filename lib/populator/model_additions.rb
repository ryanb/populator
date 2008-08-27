module Populator
  module ModelAdditions
    def populate(size)
      sql = (1..size).map do
        record = Record.new(self)
        yield(record) if block_given?
        
        "INSERT INTO #{quoted_table_name} " +
        "(#{quoted_column_names.join(', ')}) " +
        "VALUES(#{record.attribute_values.map { |v| sanitize(v) }.join(', ')})"
      end.join(';')
      connection.raw_connection.execute_batch(sql)
    end
    
    def quoted_column_names
      column_names.map do |column_name|
        connection.quote_column_name(column_name)
      end
    end
  end
end

class ActiveRecord::Base
  extend Populator::ModelAdditions
end

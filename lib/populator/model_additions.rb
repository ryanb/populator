module Populator
  module ModelAdditions
    def populate(size)
      last_id = connection.select_value("SELECT id FROM #{quoted_table_name} ORDER BY id DESC", "#{name} Last ID").to_i
      sql = (1..size).map do |i|
        record = Record.new(self, last_id+i)
        yield(record) if block_given?
        
        quoted_attributes = record.attribute_values.map { |v| sanitize(v) }
        
        "INSERT INTO #{quoted_table_name} (#{quoted_column_names.join(', ')}) VALUES(#{quoted_attributes.join(', ')})"
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

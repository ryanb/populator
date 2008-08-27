module Populator
  class Factory
    def initialize(model_class, amount)
      @model_class = model_class
      @amount = amount.kind_of?(Integer) ? amount : amount.to_a.rand
      @records = []
    end
    
    def run(&block)
      build_records(&block)
      save_records
    end
    
    private
    
    def quoted_column_names
      @model_class.column_names.map do |column_name|
        @model_class.connection.quote_column_name(column_name)
      end
    end
    
    def last_id
      @model_class.connection.select_value("SELECT id FROM #{@model_class.quoted_table_name} ORDER BY id DESC", "#{@model_class.name} Last ID").to_i
    end
    
    def build_records(&block)
      (1..@amount).map do |i|
        record = Record.new(@model_class, last_id+i)
        block.call(record) if block
        @records << record
      end
    end
    
    def save_records
      @model_class.connection.raw_connection.execute_batch(insert_statements.join(';'))
    end
    
    def insert_statements
      @records.map do |record|
        quoted_attributes = record.attribute_values.map { |v| @model_class.sanitize(v) }
        "INSERT INTO #{@model_class.quoted_table_name} (#{quoted_column_names.join(', ')}) VALUES(#{quoted_attributes.join(', ')})"
      end
    end
  end
end

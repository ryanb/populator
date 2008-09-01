module Populator
  # Builds multiple Populator::Record instances and saves them to the database
  class Factory
    DEFAULT_RECORDS_PER_QUERY = 1000
    
    @factories = {}
    @depth = 0
    
    # Fetches the factory dedicated to a given model class. You should always use this
    # method instead of instatiating a factory directly so that a single factory is
    # shared on multiple calls.
    def self.for_model(model_class)
      @factories[model_class] ||= new(model_class)
    end
    
    # Find all remaining factories and call save_records on them.
    def self.save_remaining_records
      @factories.values.each do |factory|
        factory.save_records
      end
      @factories = {}
    end
    
    # Keep track of nested factory calls so we can save the remaining records once we
    # are done with the base factory. This makes Populator more efficient when nesting
    # factories.
    def self.remember_depth
      @depth += 1
      yield
      @depth -= 1
      save_remaining_records if @depth.zero?
    end
    
    # Use for_model instead of instatiating a record directly.
    def initialize(model_class)
      @model_class = model_class
      @records = []
    end
    
    # Entry method for building records. Delegates to build_records after remember_depth.
    def populate(amount, options = {}, &block)
      self.class.remember_depth do
        build_records(Populator.interpret_value(amount), options[:per_query] || DEFAULT_RECORDS_PER_QUERY, &block)
      end
    end
    
    # Builds multiple Populator::Record instances and calls save_records them when
    # :per_query limit option is reached.
    def build_records(amount, per_query, &block)
      amount.times do
        record = Record.new(@model_class, last_id_in_database + @records.size + 1)
        @records << record
        block.call(record) if block
        save_records if @records.size >= per_query
      end
    end
    
    # Saves the records to the database by calling populate on the current database adapter.
    def save_records
      unless @records.empty?
        @model_class.connection.populate(@model_class.quoted_table_name, columns_sql, rows_sql_arr, "#{@model_class.name} Populate")
        @last_id_in_database = @records.last.id
        @records.clear
      end
    end
    
    private
    
    def quoted_column_names
      @model_class.column_names.map do |column_name|
        @model_class.connection.quote_column_name(column_name)
      end
    end
    
    def last_id_in_database
      @last_id_in_database ||= @model_class.connection.select_value("SELECT id FROM #{@model_class.quoted_table_name} ORDER BY id DESC", "#{@model_class.name} Last ID").to_i
    end
    
    def columns_sql
      "(#{quoted_column_names.join(', ')})"
    end
    
    def rows_sql_arr
      @records.map do |record|
        quoted_attributes = record.attribute_values.map { |v| @model_class.sanitize(v) }
        "(#{quoted_attributes.join(', ')})"
      end
    end
  end
end

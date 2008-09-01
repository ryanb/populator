module Populator
  # This is what is passed to the block when calling populate.
  class Record
    attr_accessor :attributes
    
    # Creates a new instance of Record and generates some accessor
    # methods for setting attributes. Some attributes are set by default:
    #
    # * <tt>id</tt> - defaults to id passed
    # * <tt>created_at</tt> - defaults to current time
    # * <tt>updated_at</tt> - defaults to current time
    # * <tt>created_on</tt> - defaults to current date
    # * <tt>updated_on</tt> - defaults to current date
    def initialize(model_class, id)
      @attributes = { :id => id }
      @columns = model_class.column_names
      @columns.each do |column|
        if column == 'created_at' || column == 'updated_at'
          @attributes[column.to_sym] = Time.now
        end
        if column == 'created_on' || column == 'updated_on'
          @attributes[column.to_sym] = Date.today
        end
        self.instance_eval <<-EOS
          def #{column}=(value)
            @attributes[:#{column}] = Populator.interpret_value(value)
          end
          
          def #{column}
            @attributes[:#{column}]
          end
        EOS
      end
    end
    
    # Return values for all columns inside an array.
    def attribute_values
      @columns.map do |column|
        @attributes[column.to_sym]
      end
    end
  end
end

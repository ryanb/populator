module Populator
  class Record
    attr_accessor :attributes
    
    def initialize(model_class, id)
      @attributes = { :id => id }
      @columns = model_class.column_names
      @columns.each do |column|
        self.instance_eval <<-EOS
          def #{column}=(value)
            @attributes[:#{column}] = interpret_value(value)
          end
          
          def #{column}
            @attributes[:#{column}]
          end
        EOS
      end
    end
    
    def attribute_values
      @columns.map do |column|
        @attributes[column.to_sym]
      end
    end
    
    private
    
    def interpret_value(value)
      case value
      when Array then value.rand
      when Range then Populator.value_in_range(value)
      else value
      end
    end
  end
end

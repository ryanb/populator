module Populator
  class Record
    attr_accessor :attributes
    
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
    
    def attribute_values
      @columns.map do |column|
        @attributes[column.to_sym]
      end
    end
  end
end

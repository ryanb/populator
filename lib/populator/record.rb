module Populator
  class Record
    attr_accessor :attributes
    
    def initialize(model_class)
      @attributes = {}
      
      model_class.column_names.each do |column|
        self.instance_eval <<-EOS
          def #{column}=(value)
            @attributes[:#{column}] = value
          end
          
          def #{column}
            @attributes[:#{column}]
          end
        EOS
      end
    end
  end
end

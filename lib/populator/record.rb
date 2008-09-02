module Populator
  # This is what is passed to the block when calling populate.
  class Record
    attr_accessor :attributes
    
    # Creates a new instance of Record. Some attributes are set by default:
    #
    # * <tt>id</tt> - defaults to id passed
    # * <tt>created_at</tt> - defaults to current time
    # * <tt>updated_at</tt> - defaults to current time
    # * <tt>created_on</tt> - defaults to current date
    # * <tt>updated_on</tt> - defaults to current date
    def initialize(model_class, id)
      @attributes = { model_class.primary_key.to_sym => id }
      @columns = model_class.column_names
      @columns.each do |column|
        if column == 'created_at' || column == 'updated_at'
          @attributes[column.to_sym] = Time.now
        end
        if column == 'created_on' || column == 'updated_on'
          @attributes[column.to_sym] = Date.today
        end
      end
    end
    
    # override id since method_missing won't catch this column name
    def id
      @attributes[:id]
    end
    
    # Return values for all columns inside an array.
    def attribute_values
      @columns.map do |column|
        @attributes[column.to_sym]
      end
    end
    
    private
    
    def method_missing(sym, *args, &block)
      name = sym.to_s
      name_without_equal = name.sub('=', '')
      if @columns.include?(name_without_equal) || @attributes.has_key?(name_without_equal.to_sym)
        if name.include? '='
          @attributes[name_without_equal.to_sym] = Populator.interpret_value(args.first)
        else
          @attributes[sym]
        end
      else
        super
      end
    end
  end
end

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
    # * <tt>type</tt> - defaults to class name (for STI)
    def initialize(model_class, id)
      @attributes = { model_class.primary_key.to_sym => id }
      @columns = model_class.column_names
      @columns.each do |column|
        case column
        when 'created_at', 'updated_at'
          @attributes[column.to_sym] = Time.now
        when 'created_on', 'updated_on'
          @attributes[column.to_sym] = Date.today
        when model_class.inheritance_column
          @attributes[column.to_sym] = model_class.to_s
        end
      end
    end

    # override id since method_missing won't catch this column name
    def id
      @attributes[:id]
    end

    # override type since method_missing won't catch this column name
    def type
      @attributes[:type]
    end

    # Return values for all columns inside an array.
    def attribute_values
      @columns.map do |column|
        @attributes[column.to_sym]
      end
    end

    def attributes=(values_hash)
      values_hash.each_pair do |key, value|
        value = value.call if value.is_a?(Proc)
        self.send((key.to_s + "=").to_sym, value)
      end
    end

    private

    def method_missing(sym, *args, &block)
      name = sym.to_s
      if @columns.include?(name.sub('=', ''))
        if name.include? '='
          @attributes[name.sub('=', '').to_sym] = Populator.interpret_value(args.first)
        else
          @attributes[sym]
        end
      else
        super
      end
    end
  end
end

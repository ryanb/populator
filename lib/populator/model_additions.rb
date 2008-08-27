module Populator
  module ModelAdditions
    def populate(size)
      size.times do
        record = Record.new(self)
        yield(record) if block_given?
        Product.create(record.attributes)
      end
    end
  end
end

class ActiveRecord::Base
  extend Populator::ModelAdditions
end

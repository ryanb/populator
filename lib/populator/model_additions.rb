module Populator
  module ModelAdditions
    def populate(amount, &block)
      Factory.new(self, amount).run(&block)
    end
  end
end

class ActiveRecord::Base
  extend Populator::ModelAdditions
end

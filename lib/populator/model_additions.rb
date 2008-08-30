module Populator
  module ModelAdditions
    def populate(amount, &block)
      Factory.for_model(self).populate(amount, &block)
    end
  end
end

class ActiveRecord::Base
  extend Populator::ModelAdditions
end

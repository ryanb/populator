module Populator
  module ModelAdditions
    def populate(amount, options = {}, &block)
      Factory.for_model(self).populate(amount, options, &block)
    end
  end
end

class ActiveRecord::Base
  extend Populator::ModelAdditions
end

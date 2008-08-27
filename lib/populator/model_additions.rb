module Populator
  module ModelAdditions
    def populate(size)
      size.times do
        create
      end
    end
  end
end

class ActiveRecord::Base
  extend Populator::ModelAdditions
end

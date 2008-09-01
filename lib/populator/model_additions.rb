module Populator
  module ModelAdditions
    # Call populate on any ActiveRecord model to fill it with data.
    # Pass the number of records you want to create, and a block to
    # set the attributes. You can nest calls to handle associations
    # and use ranges or arrays to randomize the values.
    #
    #   Person.populate(3000) do |person|
    #     person.name = "John Doe"
    #     person.gender = ['male', 'female']
    #     Project.populate(10..30, :per_query => 100) do |project|
    #       project.person_id = person.id
    #       project.due_at = 5.days.from_now..2.years.from_now
    #       project.name = Populator.words(1..3).titleize
    #       project.description = Populator.sentences(2..10)
    #     end
    #   end
    #
    # The following options are supported.
    #
    # * <tt>:per_query</tt> - limit how many records are inserted per query, defaults to 1000
    #
    # Populator::Factory is where all the work happens.
    def populate(amount, options = {}, &block)
      Factory.for_model(self).populate(amount, options, &block)
    end
  end
end

ActiveRecord::Base.class_eval do
  extend Populator::ModelAdditions
end

require "spec_helper"

describe Populator::ModelAdditions do
  it "should add populate method to active record class" do
    Product.should respond_to(:populate)
  end

  it "should add 10 records to database" do
    Product.delete_all
    Product.populate(10)
    Product.count.should == 10
  end

  it "should set attribute columns" do
    Product.populate(1) do |product|
      product.name = "foo"
    end
    Product.last.name.should == "foo"
  end

  it "should not pass in an instance of Active Record for performance reasons" do
    Product.populate(1) do |product|
      product.should_not be_kind_of(ActiveRecord::Base)
    end
  end

  it "should not pass options hash" do
    $queries_executed = []
    Product.populate(5, :per_query => 2) do |product|
      product.should_not be_kind_of(ActiveRecord::Base)
    end
    $queries_executed.grep(/^insert/i).should have(3).records
  end
end

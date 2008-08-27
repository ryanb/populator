require File.dirname(__FILE__) + '/spec_helper.rb'

describe Populator do
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
  
  it "should only use one query when inserting records" do
    $queries_executed = []
    Product.populate(10)
    $queries_executed.should have(1).record
  end
end

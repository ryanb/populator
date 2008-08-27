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
end

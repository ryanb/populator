require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Populator::Factory do
  describe "for 10 products" do
    before(:each) do
      @factory = Populator::Factory.new(Product, 10)
    end
  
    it "should only use one query when inserting records" do
      $queries_executed = []
      @factory.run
      $queries_executed.grep(/^insert/i).should have(1).record
    end
  
    it "should start id at 1 and increment when table is empty" do
      Product.delete_all
      expected_id = 1
      @factory.run do |product|
        product.id.should == expected_id
        expected_id += 1
      end
    end
  
    it "should start id at last id and increment" do
      product = Product.create
      expected_id = product.id+1
      @factory.run do |product|
        product.id.should == expected_id
        expected_id += 1
      end
    end
  end
end

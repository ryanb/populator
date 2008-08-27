require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Populator::Factory do
  describe "for 5 products" do
    before(:each) do
      @factory = Populator::Factory.new(Product, 5)
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
  
  describe "between 2 and 4 products" do
    before(:each) do
      @factory = Populator::Factory.new(Product, 2..4)
    end
    
    it "should generate within range" do
      Product.delete_all
      @factory.run
      Product.count.should >= 2
      Product.count.should <= 4
    end
  end
end

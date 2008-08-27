require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Populator::Record do
  it "should have a writer and reader methods for each column" do
    record = Populator::Record.new(Product, 1)
    Product.column_names.each do |column|
      record.send("#{column}=", "foo")
      record.send(column).should == "foo"
    end
  end
  
  it "should return attribute values in same order as columns" do
    record = Populator::Record.new(Product, nil)
    record.name = "foo"
    expected = Product.column_names.map { |c| "foo" if c == 'name' }
    record.attribute_values.should == expected
  end
  
  it "should assign second parameter to id" do
    Populator::Record.new(Product, 2).id.should == 2
  end
  
  it "should pick random number from range" do
    record = Populator::Record.new(Product, 1)
    record.stock = 2..5
    record.stock.should >= 2
    record.stock.should <= 5
  end
  
  it "should pick random value from array" do
    record = Populator::Record.new(Product, 1)
    record.name = %w[foo bar]
    %w[foo bar].should include(record.name)
  end
end

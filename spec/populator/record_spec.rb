require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Populator::Record do
  it "should have a writer and reader methods for each column" do
    record = Populator::Record.new(Product)
    Product.column_names.each do |column|
      record.send("#{column}=", "foo")
      record.send(column).should == "foo"
    end
  end
  
  it "should return attribute values in same order as columns" do
    record = Populator::Record.new(Product)
    record.name = "foo"
    expected = Product.column_names.map { |c| "foo" if c == 'name' }
    record.attribute_values.should == expected
  end
end

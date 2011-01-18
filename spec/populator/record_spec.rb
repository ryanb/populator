require "spec_helper"

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

  it "should automatically set created/updated columns" do
    Product.stubs(:column_names).returns(%w[id created_at updated_at created_on updated_on])
    record = Populator::Record.new(Product, 1)
    record.created_at.to_date.should == Date.today
    record.updated_at.to_date.should == Date.today
    record.created_on.should == Date.today
    record.updated_on.should == Date.today
  end

  it "should use custom primary_key for auto-increment if specified" do
    Product.stubs(:primary_key).returns('foo')
    Product.stubs(:column_names).returns(['foo', 'name'])
    Populator::Record.new(Product, 123).foo.should == 123
  end

  it "should default type to class name" do
    Product.stubs(:column_names).returns(['id', 'type'])
    Populator::Record.new(Product, 1).type.should == 'Product'
  end

  it "should default specified inheritance_column to class name" do
    Product.stubs(:inheritance_column).returns('foo')
    Product.stubs(:column_names).returns(['id', 'foo'])
    Populator::Record.new(Product, 1).foo.should == 'Product'
  end

  it "should allow set via attributes hash" do
    record = Populator::Record.new(Product, 1)
    record.attributes = {:stock => 2..5}
    record.stock.should >= 2
    record.stock.should <= 5
  end

  it "should take a proc object via attributes hash" do
    record = Populator::Record.new(Product, 1)
    record.attributes = {:stock => lambda {15}}
    record.stock.should == 15
  end
end

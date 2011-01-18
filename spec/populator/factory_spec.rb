require "spec_helper"

describe Populator::Factory do
  describe "for products" do
    before(:each) do
      @factory = Populator::Factory.for_model(Product)
    end

    it "should only use one query when inserting records" do
      $queries_executed = []
      @factory.populate(5)
      $queries_executed.grep(/^insert/i).should have(1).record
    end

    it "should start id at 1 and increment when table is empty" do
      Product.delete_all
      expected_id = 1
      @factory.populate(5) do |product|
        product.id.should == expected_id
        expected_id += 1
      end
    end

    it "should start id at last id and increment" do
      Product.delete_all
      product = Product.create
      expected_id = product.id+1
      @factory.populate(5) do |product|
        product.id.should == expected_id
        expected_id += 1
      end
    end

    it "should generate within range" do
      Product.delete_all
      @factory.populate(2..4)
      Product.count.should >= 2
      Product.count.should <= 4
    end

    it "should limit number of records per query" do
      $queries_executed = []
      @factory.populate(5, :per_query => 2)
      $queries_executed.grep(/^insert/i).should have(3).records
    end
  end

  it "should only use two queries when nesting factories (one for each class)" do
    $queries_executed = []
    Populator::Factory.for_model(Category).populate(3) do |category|
      Populator::Factory.for_model(Product).populate(3) do |product|
        product.category_id = category.id
      end
    end
    $queries_executed.grep(/^insert/i).should have(2).records
  end

  it "should only use one query when nesting factories of the same type" do
    $queries_executed = []
    Populator::Factory.for_model(Product).populate(3) do |product|
      Populator::Factory.for_model(Product).populate(3)
    end
    $queries_executed.grep(/^insert/i).should have(1).record
  end

  it "should default to 1000 records per query" do
    Populator::Factory::DEFAULT_RECORDS_PER_QUERY.should == 1000
  end
end

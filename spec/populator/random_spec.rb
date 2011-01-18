require "spec_helper"

describe Populator::Random do
  it "should pick a random number in range excluding last value" do
    Populator.stubs(:rand).with(5).returns(3)
    Populator.value_in_range(10...15).should == 13
  end

  it "should pick a random number in range including last value" do
    Populator.stubs(:rand).with(5).returns(3)
    Populator.value_in_range(10..14).should == 13
  end

  it "should pick a random time in range" do
    start_time = 2.days.ago
    end_time = Time.now
    Populator.stubs(:rand).with(end_time.to_i-start_time.to_i).returns(1)
    Populator.value_in_range(start_time...end_time).should == Time.at(start_time.to_i + 1)
  end

  it "should pick a random date in range" do
    start_date = 2.years.ago.to_date
    end_date = Date.today
    Populator.stubs(:rand).with(end_date.jd-start_date.jd).returns(1)
    Populator.value_in_range(start_date...end_date).should == Date.jd(start_date.jd + 1)
  end

  it "should pick a random string by converting to array" do
    Populator.stubs(:rand).with(5).returns(2)
    Populator.value_in_range('a'..'e').should == 'c'
  end

  it "should pick 3 random words" do
    Populator.words(3).split.should have(3).records
  end

  it "should pick a random number of random words" do
    Populator.stubs(:rand).returns(3)
    Populator.words(10...15).split.should have(13).records
  end

  it "should generate 3 random sentences" do
    Populator.sentences(3).split(/\. [A-Z]/).should have(3).records
  end

  it "should generate 3 random paragraphs" do
    Populator.paragraphs(3).split(/\n\n/).should have(3).records
  end
end

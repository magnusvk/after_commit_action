require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/tester'

describe "AfterCommitAction" do
  it "should correctly execute tasks after commit" do
    t = Tester.new
    t.array.should be_empty
    t.save!
    t.array.size.should == 2
    t.array.should include('before_create')
    t.array.should include('after_create')

    t = Tester.first
    t.array.should be_empty
    t.save!
    t.array.size.should == 2
    t.array.should include('before_update')
    t.array.should include('after_update')
  end
end

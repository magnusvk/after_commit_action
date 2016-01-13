require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/tester'
require 'models/another_model'

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

  context 'when block is executed in another model transaction' do
    let(:tester)        { Tester.create count: 0 }
    let(:another_model) { AnotherModel.new tester: tester }

    subject {}

    it "increments the counter" do
      expect { another_model.save! }.to change { tester.reload.count }.from(0).to 1
    end
  end

  context 'when there is no transaction' do
    let(:tester) { Tester.create count: 0 }

    it "increments the counter" do
      expect { tester.increment_counter }.to change { tester.reload.count }.from(0).to 1
    end
  end
end

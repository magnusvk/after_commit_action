require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'models/tester'
require 'models/another_model'

describe "AfterCommitAction" do
  it "should correctly execute tasks after commit" do
    t = Tester.new
    expect(t.array).to be_empty
    t.save!
    expect(t.array.size).to eq(2)
    expect(t.array).to include('before_create')
    expect(t.array).to include('after_create')

    t = Tester.first
    expect(t.array).to be_empty
    t.save!
    expect(t.array.size).to eq(2)
    expect(t.array).to include('before_update')
    expect(t.array).to include('after_update')
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

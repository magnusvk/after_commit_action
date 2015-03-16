class AnotherModel < ActiveRecord::Base
  include AfterCommitAction

  belongs_to :tester

  after_save :increment_tester_counter

  def increment_tester_counter
    tester.increment_counter
  end
end

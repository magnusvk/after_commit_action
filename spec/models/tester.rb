class Tester < ActiveRecord::Base
  include AfterCommitAction

  after_initialize :after_initialize

  before_create :before_create
  after_create :after_create
  before_update :before_update
  after_update :after_update

  attr_reader :array

  def after_initialize
    @array = []
  end

  def before_create
    execute_after_commit { @array<< 'before_create' }
  end

  def after_create
    execute_after_commit { @array<< 'after_create' }
  end

  def before_update
    execute_after_commit { @array<< 'before_update' }
  end

  def after_update
    execute_after_commit { @array<< 'after_update' }
  end

  def increment_counter
    execute_after_commit { increment! :count }
  end
end

# use this module to defer actions to the after-commit hook. this is useful if you want
# to trigger actions in after_create, after_destroy and after_update callbacks but want
# to execute them outside of the transaction (for example, to avoid deadlocks).
#
# Usage:
# after_create :my_hook
# def my_hook
#   execute_after_commit { puts "This is called after committing the transaction. "}
# end

module AfterCommitAction

  module ActiveRecord

    def self.included(base)
      base.after_commit :_after_commit_hook
    end

    def execute_after_commit(&block)
      @_execute_after_commit ||= []
      @_execute_after_commit<< block
    end

    def _after_commit_hook
      begin
        until @_execute_after_commit.blank?
          @_execute_after_commit.shift.call
        end
      rescue => e
        if defined?(Exceptional)
          # Rails quietly swallows exceptions in after-commit actions; to avoid missing these
          # exceptions, we pass them to Exceptional explicitly
          Exceptional.context(:after_commit_entity => self.inspect)
          Exceptional.handle(e, "execute_after_commit")
        else
          Rails.logger.error "Error in execute_after_commit block: #{e.inspect}"
        end
        raise e
      end
    end

  end

  if defined?(Rails) # if this is a full blown rails app, use a railtie. This avoids deprecation warnings in Rails 4.2
    class Railtie < Rails::Railtie
      initializer "active_record.include_plugins" do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Base.send :include, ActiveRecord
        end
      end
    end
  else
    ::ActiveRecord::Base.send :include, ActiveRecord
  end
end

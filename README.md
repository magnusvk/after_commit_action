# after_commit_action

Use this module to defer actions to the after-commit hook. This is useful if you want to trigger actions in after_create, after_destroy and after_update callbacks but want to execute them outside of the transaction (for example, to avoid deadlocks).

## Usage

```ruby
include AfterCommitAction
after_create :my_hook
def my_hook
  execute_after_commit { puts "This is called after committing the transaction. "}
end
```

## Contributing to after_commit_action
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 BestVendor. See LICENSE.txt for
further details.

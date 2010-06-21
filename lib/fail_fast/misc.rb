class FailFast
  module Misc

    # Usage
    #   if 0 == Time.now.wday
    #     fail "I don't work on Sunday""
    #   end
    def fail(message)
      FailFast.errors << ErrorDetails.new(nil, :fail, message)
    end

    def only_if(condition, &block)
      yield if condition
    end

    def skip_if(condition, &block)
      yield if !condition
    end
  end
end
FailFast.send  :include, FailFast::Misc
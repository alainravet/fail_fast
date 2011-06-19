class FailFast
  module ErrorReporter
    autoload :Base,       'fail_fast/error_reporter/base'
    autoload :Stdout,     'fail_fast/error_reporter/stdout'
  end
end

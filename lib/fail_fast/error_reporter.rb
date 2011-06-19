class FailFast
  module ErrorReporter
    autoload :Base,       'fail_fast/error_reporter/base'
    autoload :Stdout,     'fail_fast/error_reporter/stdout'
    autoload :Hoptoad,    'fail_fast/error_reporter/hoptoad'
  end
end

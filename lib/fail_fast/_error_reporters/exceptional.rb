begin
  require 'exceptional'
rescue LoadError
end

module FailFast::ErrorReporter
  class Exceptional < Base

    def initialize(api_key)
      @api_key = api_key
    end

    def self.to_sym
      :exceptional
    end

    def report(errors, context)
      path = context[:config_file_path]
      path = File.basename(path) if $fail_fast_shorten_path_in_reports

      msg = "FailFast error in #{path}"
      backtrace = errors.collect {|e| default_message_for(e, false)}.join("\n")
      notify_hoptoad(msg, backtrace)
    end

  private
    def notify_hoptoad(msg, backtrace)
      ::Exceptional::Config.api_key = @api_key
      ::Exceptional::Config.enabled = true

      ::Exceptional.handle Error.new(msg, backtrace), msg
    end
  end
end

class FailFast::ErrorReporter::Exceptional
  class Error < RuntimeError
    attr_reader :backtrace
    def initialize(msg, backtrace)
      super(msg)
      @backtrace = Array(backtrace)
    end
  end
end

FailFast::ErrorReporter::Registry.register(FailFast::ErrorReporter::Exceptional)



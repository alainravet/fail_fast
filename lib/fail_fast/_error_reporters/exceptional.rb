require 'exceptional'

module FailFast::ErrorReporter
  class Exceptional < Base

    def initialize(api_key)
      @api_key = api_key
    end

    def self.to_sym
      :exceptional
    end

    def report(errors, context)
      msg = "FailFast error in #{context[:config_file_path]}"
      backtrace = errors.collect {|e| default_message_for(e, false)}.join("\n")
      report_to_getexceptional(msg, backtrace)
    end

  private
    def report_to_getexceptional(msg, backtrace)
      ::Exceptional::Config.api_key = 'a508c1bb4d013ad68c9d4bf707dc24b3eebfc4f7'
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



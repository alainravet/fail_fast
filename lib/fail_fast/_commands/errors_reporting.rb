class FailFast
  module ErrorReporting

    def self.included(base)
      base.extend(ClassMethods)
    end


# ------------------------------ Instance methods -------------------------------

    def error_reporters
      @_current_error_reporters ||= []
    end

    def activate_errors_reporter(reporter)
      error_reporters.push reporter unless error_reporters.include?(reporter)
    end

  end
end

# -------------------------------- Class methods --------------------------------
class FailFast
  module ErrorReporting::ClassMethods

    # Usage :
    #   FailFast.reporter {:hoptoad => 'your-hop-api-key', :exceptional => 'you-exc-api-key'}
    #   FailFast.reporter MyReporter.new(...)
    def report_to(params)
      if params.is_a?(Hash)
        reporters = params.collect {|key, value| FailFast::ErrorReporter.build_from(key, value) }
        reporters.each do |reporter|
          activate_error_reporter reporter
        end
      else
        reporter = params
        Array(activate_error_reporter(reporter))
      end
    end

    def activated_error_reporters
      @@_activated_error_reporters ||= [default_error_reporter]
    end


  private
    def activate_error_reporter(reporter)
      activated_error_reporters.push(reporter) unless activated_error_reporters.include?(reporter)
      reporter
    end

    def default_error_reporter
      @@_default_reporter ||= FailFast::ErrorReporter::Registry.get(:stdout).new(nil)
    end

    def reset_activated_error_reporters
      @@_activated_error_reporters = [default_error_reporter]
    end

  end
end


FailFast.send  :include, FailFast::ErrorReporting
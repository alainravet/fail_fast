class FailFast
  module ErrorReporter
    # Input :
    #    :hoptoad, 'your-hoptoad-api-key'
    # Output :
    #  FailFast::ErrorReporter::Hoptoad.new 'your-hoptoad-api-key'
    def self.build_from(reporter_sym, params)
      FailFast::ErrorReporter::Registry.get(reporter_sym).new(params)
    end

  end
end

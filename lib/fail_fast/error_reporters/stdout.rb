module FailFast::ErrorReporter
  class Stdout < Base
    ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

    def initialize(ignored=nil)
    end

    def self.to_sym
      :stdout
    end

    def report(errors, context)
      puts "\n\n\n" + ERB.new(File.read(FailFast::ErrorReporter::Stdout::ERB_TEMPLATE)).result(binding) + "\n\n"
    end
  end
end

FailFast::ErrorReporter::Registry.register(FailFast::ErrorReporter::Stdout)
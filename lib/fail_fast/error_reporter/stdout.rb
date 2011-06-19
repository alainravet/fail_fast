module FailFast::ErrorReporter
  class Stdout < Base
    ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

    def report(errors, context)
      puts "\n\n\n" + ERB.new(File.read(FailFast::ErrorReporter::Stdout::ERB_TEMPLATE)).result(binding) + "\n\n"
    end
  end
end
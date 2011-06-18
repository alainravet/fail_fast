module FailFast::ErrorReporter
  class Stdout
    ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

    include FailFast::Utils     # for lred, ..
    include FailFast::Messaging # for default_messaging, ..


    def report(errors, binding_)
      puts "\n\n\n" + ERB.new(File.read(FailFast::ErrorReporter::Stdout::ERB_TEMPLATE)).result(binding_) + "\n\n"
    end

  end
end
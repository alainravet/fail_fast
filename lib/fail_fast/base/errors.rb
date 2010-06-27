module FailFast::Errors
  ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

  def print_errors_and_exit
    @errors = errors
    puts "\n\n\n" + ERB.new(File.read(ERB_TEMPLATE)).result(binding) + "\n\n"
    exit
  end
end
FailFast.send  :include, FailFast::Errors
require 'hoptoad_notifier'

module FailFast::ErrorReporter
  class HoptoadGem < Base

    def initialize(api_key)
      @api_key = api_key
    end

    def self.to_sym
      :hoptoad_gem
    end

    def report(errors, context)
      path = context[:config_file_path]
      path = File.basename(path) if $fail_fast_shorten_path_in_reports

      msg       = "FailFast error in #{path}"
      backtrace = errors_to_backtrace(errors, path)
      notify_hoptoad(msg, backtrace)
    end

  private

    def errors_to_backtrace(errors, path)
      [].tap do |traces|
        errors.each_with_index do |error, i|
          error_as_trace_path = default_message_for(error, false)
          #Limitation of the HoptoadNotifier gem : no ':' in the trace path
          error_as_trace_path.gsub!(':','_')  #
          traces << "#{error_as_trace_path}:#{ 1+i }:in `#{path}'"
        end
      end
    end


    def notify_hoptoad(msg, backtrace)
      ::HoptoadNotifier.configure do |config|
        config.api_key      = @api_key
      end

      ::HoptoadNotifier.notify(
        :error_class   => "FailFast Error",
        :error_message => msg,
        :backtrace     => backtrace
      )
    end
  end
end


FailFast::ErrorReporter::Registry.register(FailFast::ErrorReporter::HoptoadGem)


__END__
from https://github.com/thoughtbot/hoptoad_notifier
Example :
  begin
    params = {
      # params that you pass to a method that can throw an exception
    }
    my_unpredicable_method(params)
  rescue => e
    HoptoadNotifier.notify(
      :error_class   => "Special Error",
      :error_message => "Special Error: #{e.message}",
      :parameters    => params
    )
  end

Hoptoad merges the hash you pass with these default options:

{
  :api_key       => HoptoadNotifier.api_key,
  :error_message => 'Notification',
  :backtrace     => caller,
  :parameters    => {},
  :session       => {}
}
require 'net/http'
module FailFast::ErrorReporter
  class HoptoadRaw < Base
    REQUEST_ERB_TEMPLATE = File.join(File.dirname(__FILE__), 'hoptoad_raw', 'post_error_request.xml.erb')

    attr_reader :response

    def initialize(api_key)
      @api_key = api_key
    end

    def self.to_sym
      :hoptoad_raw
    end

    def report(errors, context)
      path = context[:config_file_path]
      path = File.basename(path) if $fail_fast_shorten_path_in_reports
      uri = URI.parse('http://hoptoadapp.com/notifier_api/v2/notices')
      @response = Net::HTTP.start(uri.host, uri.port) {|http|
        req = Net::HTTP::Post.new(uri.path)
        req['Content-Type'] = 'text/xml'
        req['Accept'      ] = 'text/xml'
        http.request(req, xml_req(errors, path))
      }
    end

  private
    def xml_req(errors, path)
      config_path       = path
      project_root      = '/testapp'
      environment_name  = 'test'
      app_version       = '1.0.0'
      error_msg         = default_message_for(errors.first, false)

      ERB.new(File.read(REQUEST_ERB_TEMPLATE)).result(binding).gsub(/[\t\r\n]/,'')
    end

  end
end

FailFast::ErrorReporter::Registry.register(FailFast::ErrorReporter::HoptoadRaw)
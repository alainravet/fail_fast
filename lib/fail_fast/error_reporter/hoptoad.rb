module FailFast::ErrorReporter
  class Hoptoad < Base
    REQUEST_ERB_TEMPLATE = File.join(File.dirname(__FILE__), 'hoptoad', 'post_error_request.xml.erb')

    attr_reader :response

    def initialize(api_key)
      @api_key = api_key
    end

    def report(errors, context)
      require 'net/http'
      uri = URI.parse('http://hoptoadapp.com/notifier_api/v2/notices')
      @response = Net::HTTP.start(uri.host, uri.port) {|http|
        req = Net::HTTP::Post.new(uri.path)
        req['Content-Type'] = 'text/xml'
        req['Accept'      ] = 'text/xml'
        http.request(req, xml_req(errors, context))
      }
    end

  private
    def xml_req(errors, context)
      config_path       = context[:config_file_path]
      project_root      = '/testapp'
      environment_name  = 'test'
      app_version       = '1.0.0'
      error_msg         = default_message_for(errors.first, false)

      ERB.new(File.read(REQUEST_ERB_TEMPLATE)).result(binding).gsub(/[\t\r\n]/,'')
    end

  end
end

FailFast::ErrorReporter::Registry.register(:hoptoad, FailFast::ErrorReporter::Hoptoad)
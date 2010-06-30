class FailFast
  module Base
    ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

    def check(&block)
      config_file_not_found = !File.exist?(@config_file_path)
      if config_file_not_found
        add_error ErrorDetails.new(nil, :config_file_not_found, @config_file_path)
      else
        check_all_rules(&block)
      end
      print_errors_and_exit unless errors.empty?
    end

  private

    def check_all_rules(&block)
      @yaml_config_as_hash = YAML.load(ERB.new(File.read(@config_file_path)).result) || {}
      self.instance_eval(&block)
    end

    def print_errors_and_exit
      @errors = errors
      puts "\n\n\n" + ERB.new(File.read(ERB_TEMPLATE)).result(binding) + "\n\n"
      exit
    end
  end
end

FailFast.send  :include, FailFast::Base
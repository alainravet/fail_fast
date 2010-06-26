class FailFast
  module Base

    def check(&block)
      config_file_not_found = !File.exist?(@config_file_path)
      if config_file_not_found
        FailFast.errors << ErrorDetails.new(nil, :config_file_not_found, @config_file_path)
      else
        check_all_rules(&block)
      end
      raise_and_print_errors if errors?
    end

  private

    def check_all_rules(&block)
      @config_as_hash = YAML.load(ERB.new(File.read(@config_file_path)).result) || {}
      self.instance_eval(&block)
    end

  end
end

FailFast.send  :include, FailFast::Base
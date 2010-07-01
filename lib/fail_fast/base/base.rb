class FailFast
  module Base
    ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

    def check(&block)
      fail_now_mode   = block_given? # false in the case of  *.check_now.but_fail_now do .. end

      @config_file_not_found = !File.exist?(@config_file_path)
      if @config_file_not_found
        add_error ErrorDetails.new(nil, :config_file_not_found, @config_file_path)
      else
        check_all_rules(&block) if block_given?
      end
      unless errors.empty?
        print_errors
        exit(1) if fail_now_mode
      end
      self
    end

    alias check_now check

    def but_fail_later(&block)
      return if @config_file_not_found
      check_all_rules(&block) if block_given?
      unless errors.empty?
        print_errors
      end
    end
  private

    def check_all_rules(&block)
      @yaml_config_as_hash = YAML.load(ERB.new(File.read(@config_file_path)).result) || {}
      self.instance_eval(&block)
    end

    def print_errors
      @errors = errors
      puts "\n\n\n" + ERB.new(File.read(ERB_TEMPLATE)).result(binding) + "\n\n"
    end
  end
end

FailFast.send  :include, FailFast::Base
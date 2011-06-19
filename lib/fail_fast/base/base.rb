class FailFast
  module Base
    def check(&block)
      fail_now_mode   = block_given? # false in the case of  *.check_now.but_fail_now do .. end

      @config_file_not_found = @config_file_path && !File.exist?(@config_file_path)
      if @config_file_not_found
        add_error ErrorDetails.new(nil, :config_file_not_found, @config_file_path)
      else
        check_all_rules(&block) if block_given?
      end
      unless errors.empty?
        report_errors
        exit(1) if fail_now_mode
      end
      self
    end

    alias check_now check

    def but_fail_later(&block)
      return if @config_file_not_found
      check_all_rules(&block) if block_given?
      unless errors.empty?
        report_errors
      end
    end
  private

    def check_all_rules(&block)
      @yaml_config_as_hash = (@config_file_path && YAML.load(ERB.new(File.read(@config_file_path)).result)) || {}
      self.instance_eval(&block)
    end

    def report_errors #:nodoc:
      context = {
          :errors_to_report => errors,
          :config_file_path => @config_file_path,
          :keys_prefix      => @keys_prefix,
      }
      error_reporters.each do |reporter|
        reporter.report(errors, context)
      end
    end
  end
end

FailFast.send  :include, FailFast::Base
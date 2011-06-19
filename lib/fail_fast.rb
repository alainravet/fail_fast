require 'yaml'
require 'erb'

require File.expand_path(File.dirname(__FILE__) + '/fail_fast/support/error_db')
class FailFast

  @@_errors_db = FailFast::ErrorDb.new
  @@global_error_reporters = nil

  def initialize(config_file_path=nil, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
    @errors_key       = ErrorDb.key_for(config_file_path, keys_prefix)
    FailFast.global_error_reporters.each do |r| register_errors_reporter(r) end
  end


  class << self
    def fail_now
      exit(1) unless errors_db.keys.empty?
    end

    def failed?
      !global_errors.empty?
    end

    def errors_db #:nodoc:
      @@_errors_db
    end

    # @param reporters [Object] 1 or many error reporters (must respond to :report)
    def report_to(*reporters)
      reporters.each do |r| add_global_error_reporter(r) end
    end

    def global_error_reporters
      reset_global_error_reporters unless @@global_error_reporters
      @@global_error_reporters
    end
  private
    def reset_global_error_reporters
      @@global_error_reporters = [ErrorReporter::Stdout.new]
    end

    def add_global_error_reporter(reporter)
      global_error_reporters.push(reporter) unless global_error_reporters.include?(reporter)
    end
  end


  def add_error(value)
    @@_errors_db.append(@errors_key, value)
  end

  def errors
    @@_errors_db.errors_for(@errors_key)
  end



  def error_reporters
    @error_reporters ||= []
  end

  # @param reporters [Object] 1 or many error reporters (must respond to :report)
  def register_errors_reporters(*reporters)
    reporters.each do |r| register_errors_reporter(r) end
  end

  def register_errors_reporter(reporter)
    error_reporters.push reporter unless error_reporters.include?(reporter)
  end
end

Dir.glob(File.dirname(__FILE__) + '/fail_fast/support/*.rb'   ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/base/*.rb'      ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/extensions/*.rb') {|file| require file }

require 'fail_fast/error_reporter'

# alternative syntax
def FailFast(config_file_path=nil, keys_prefix=nil)
  FailFast.new(config_file_path, keys_prefix)
end


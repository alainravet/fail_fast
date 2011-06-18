require 'yaml'
require 'erb'

require File.expand_path(File.dirname(__FILE__) + '/fail_fast/support/error_db')
class FailFast
  attr_reader :error_reporters

  @@_errors_db = FailFast::ErrorDb.new

  def initialize(config_file_path, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
    @errors_key       = ErrorDb.key_for(config_file_path, keys_prefix)
    @error_reporters  = [ErrorReporter::Stdout.new]
  end

  def self.fail_now
    exit(1) unless errors_db.keys.empty?
  end

  def self.failed?
    !global_errors.empty?
  end

  def self.errors_db #:nodoc:
    @@_errors_db
  end

  def add_error(value)
    @@_errors_db.append(@errors_key, value)
  end

  def errors
    @@_errors_db.errors_for(@errors_key)
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


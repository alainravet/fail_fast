require 'yaml'
require 'erb'
require File.expand_path(File.dirname(__FILE__) + '/support/error_db')

class FailFast

  @@_errors_db = FailFast::ErrorDb.new

  def initialize(config_file_path, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
    @errors_key       = ErrorDb.key_for(config_file_path, keys_prefix)
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

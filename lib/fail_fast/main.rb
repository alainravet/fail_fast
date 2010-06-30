require 'yaml'
require 'erb'
require File.expand_path(File.dirname(__FILE__) + '/support/error_db')

class FailFast

  @@_errors_db = FailFast::ErrorDb.new

  def initialize(config_file_path, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
  end

  def add_error(value)
    filter = @config_file_path
    @@_errors_db.append(filter, value)
  end

  def errors
    @@_errors_db.errors_for(@config_file_path)
  end
end

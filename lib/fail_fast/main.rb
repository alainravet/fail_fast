require 'yaml'
require 'erb'

class FailFast

  def initialize(config_file_path, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
    @@_errors = []
  end

  def self.errors
    @@_errors
  end

  def errors?
    !FailFast.errors.empty?
  end

end
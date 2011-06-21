require 'yaml'
require 'erb'

require File.expand_path(File.dirname(__FILE__) + '/fail_fast/support/error_db')
class FailFast


  def initialize(config_file_path=nil, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
    @errors_key       = ErrorDb.key_for(config_file_path, keys_prefix)
    FailFast.activated_error_reporters.each do |r| activate_errors_reporter(r) end
  end


  class << self
    def fail_now
      exit(1) unless errors_db.keys.empty?
    end

    def failed?
      !global_errors.empty?
    end

  end

end

Dir.glob(File.dirname(__FILE__) + '/fail_fast/support/*.rb'   ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/base/*.rb'      ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/extensions/*.rb') {|file| require file }

require 'fail_fast/error_reporter'
require 'fail_fast/error_reporter/registry'
Dir.glob(File.dirname(__FILE__) + '/fail_fast/error_reporter/*.rb') {|file| require file }

# alternative syntax
def FailFast(config_file_path=nil, keys_prefix=nil)
  FailFast.new(config_file_path, keys_prefix)
end


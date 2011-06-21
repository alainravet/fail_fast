class FailFast

  def initialize(config_file_path=nil, keys_prefix=nil)
    @config_file_path = config_file_path
    @keys_prefix      = keys_prefix
    @errors_key       = ErrorDb.key_for(config_file_path, keys_prefix)
    FailFast.activated_error_reporters.each do |r| activate_errors_reporter(r) end
  end

end

Dir.glob(File.dirname(__FILE__) + '/fail_fast/base/*.rb'          ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/commands/*.rb'      ) {|file| require file }
require 'fail_fast/error_reporter'
Dir.glob(File.dirname(__FILE__) + '/fail_fast/error_reporters/*.rb') {|file| require file }

# alternative syntax
def FailFast(config_file_path=nil, keys_prefix=nil)
  FailFast.new(config_file_path, keys_prefix)
end


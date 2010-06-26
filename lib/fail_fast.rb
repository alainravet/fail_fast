require 'fail_fast/main'

# load all the extensions
Dir.glob(File.dirname(__FILE__) + '/fail_fast/extensions/*.rb') {|file| require file }


def FailFast(config_file_path, keys_prefix=nil)
  FailFast.new(config_file_path, keys_prefix)
end


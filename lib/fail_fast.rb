require 'fail_fast/main'
Dir.glob(File.dirname(__FILE__) + '/fail_fast/base/*.rb') {|file| require file }

# load all the extensions
Dir.glob(File.dirname(__FILE__) + '/fail_fast/extensions/*.rb') {|file| require file }


# alternative syntax
def FailFast(config_file_path, keys_prefix=nil)
  FailFast.new(config_file_path, keys_prefix)
end


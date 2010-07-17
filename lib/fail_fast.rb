require 'fail_fast/main'
Dir.glob(File.dirname(__FILE__) + '/fail_fast/support/*.rb'   ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/base/*.rb'      ) {|file| require file }
Dir.glob(File.dirname(__FILE__) + '/fail_fast/extensions/*.rb') {|file| require file }


# alternative syntax
def FailFast(config_file_path=nil, keys_prefix=nil)
  FailFast.new(config_file_path, keys_prefix)
end


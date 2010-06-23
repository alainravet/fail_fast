require 'fail_fast/main'

# load all the extensions
Dir.glob(File.dirname(__FILE__) + '/fail_fast/extensions/*.rb') {|file| require file }


def FailFast(path, prefix=nil)
  FailFast.new(path, prefix)
end


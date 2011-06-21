require 'rubygems'
require 'fail_fast'

require 'spec'
require 'timecop'
require 'mongo'
require 'active_support/inflector'

SPEC_DIR          = File.dirname(File.expand_path(__FILE__))

UNKNOWN_FILE_PATH =   'an_unknown_file_path'
EMPTY_FILE_PATH   =   SPEC_DIR + '/_/fixtures/empty.yml'
SIMPLE_FILE_PATH  =   SPEC_DIR + '/_/fixtures/simple.yml'


#------------------------------------------------------------------------
# Freeze some value so the test are not location nor time dependent :
#------------------------------------------------------------------------
require 'time'
FROZEN_TIME = Time.parse('1999-05-04 03:02:01 +0200')


require 'socket' unless defined?(Socket)
class Socket
  def self.gethostname    # The Hoptoad and Exceptional gems use this method
    'my-host-name'        # to obtain the hostname value
  end
end

#------------------------------------------------------------------------

Spec::Runner.configure do |config|
  config.before(:each) do
    FailFast.reset_error_db!
    FailFast.send :reset_activated_error_reporters
    # to make the tests run on any machine/in any location :
    $fail_fast_shorten_path_in_reports = true
  end
end

Dir[File.join(SPEC_DIR, '_/support/**/*.rb')].each {|f| require f}


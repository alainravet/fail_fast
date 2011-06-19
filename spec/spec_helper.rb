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

require 'time'
FROZEN_TIME = Time.parse('1999-05-04 03:02:01 +0200')


Spec::Runner.configure do |config|
  config.before(:each) do
    FailFast.reset_error_db!
    FailFast.send :reset_global_error_reporters
  end
end


Dir[File.join(SPEC_DIR, '_/support/**/*.rb')].each {|f| require f}

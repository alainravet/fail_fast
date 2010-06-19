require 'fail_fast'
require 'spec'
require 'spec/autorun'
require 'fakeweb'
require 'mongo'

SPEC_DIR = File.dirname(File.expand_path(__FILE__))
UNKNOWN_FILE_PATH =   'an_unknown_file_path'
EMPTY_FILE_PATH   =   File.expand_path(File.dirname(__FILE__) + '/fixtures/empty.yml')
SIMPLE_FILE_PATH  =   File.expand_path(File.dirname(__FILE__) + '/fixtures/simple.yml')


module DSLMacros
  module ClassMethods
    def it_should_not_raise_an_error(msg, &block)
      it "should not raise an error #{msg}" do
        lambda{
          FailFast.config_file(SIMPLE_FILE_PATH).check do
            self.instance_eval(&block)
          end
        }.should_not raise_error
      end
    end

    def it_should_raise_an_error(msg, pattern=nil, &block)
      it "should raise an error #{msg}" do
        lambda{
          FailFast.config_file(SIMPLE_FILE_PATH).check do
            self.instance_eval(&block)
          end
        }.should raise_error(FailFast::Error, pattern)
      end
    end

  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end
end
Spec::Runner.configure do |config|
  config.include(DSLMacros)
end

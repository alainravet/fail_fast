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
        begin
          FailFast(SIMPLE_FILE_PATH).check do
            raise "BUG : @@errorz should be empty \n#{FailFast.errors.inspect}"  unless FailFast.errors.empty?
            self.instance_eval(&block)
          end
        rescue => e
          raise e
        ensure
          if 1 <= FailFast.errors.length
            fail "ZZshould not have raised an error, but it raised\n#{FailFast.errors.join("\n")}"
          end
        end

      end
    end

    def it_should_raise_an_error(key, kind, msg, &block)
      it "should raise an error #{key}-#{msg}" do
        begin
          FailFast(SIMPLE_FILE_PATH).check do
            raise "BUG : @@errorz should be empty \n#{FailFast.errors.inspect}"  unless FailFast.errors.empty?
            self.instance_eval(&block)
          end
        rescue => e
          # uncomment the next line after the refactoring/once error are no longer raise
          #  raise e
        ensure
          if FailFast.errors.empty?
            fail "\ne2d\nshould have raised a #{kind} error for #{key} \n==#{e}"
          elsif FailFast.errors.length == 1 && !FailFast.errors.first.has_key_and_kind?(key, kind)
            fail "\ne2e\nshould have raised a #{kind.inspect} error for #{key.inspect}, but raised instead #{FailFast.errors.inspect}"
          elsif 2 <= FailFast.errors.length
            fail "\ne2f\nshould have raised only a #{kind} error for #{key}\n#{FailFast.errors.join("\n")}"
          end
        end

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

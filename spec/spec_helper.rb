require 'fail_fast'
require 'spec'
require 'spec/autorun'
require 'fakeweb'
require 'mongo'

SPEC_DIR = File.dirname(File.expand_path(__FILE__))
UNKNOWN_FILE_PATH =   'an_unknown_file_path'
EMPTY_FILE_PATH   =   File.expand_path(File.dirname(__FILE__) + '/fixtures/empty.yml')
SIMPLE_FILE_PATH  =   File.expand_path(File.dirname(__FILE__) + '/fixtures/simple.yml')

module Kernel
  def exit(param=nil)
    raise "Kernel.exit was called"
  end
end


module DSLMacros
  module InstanceMethods
    def capture_stdout
      @@original_stdout = STDOUT
      $stdout = StringIO.new
    end

    def restore_stdout
      $stdout = @@original_stdout
    end
  end
  module ClassMethods

    def it_should_not_raise_an_error(msg, &block)
      it "should not raise an error #{msg}" do
        capture_stdout
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
        restore_stdout
      end
    end

    def it_should_raise_an_error(key, kind, msg, &block)
      it "should raise an error #{kind}-#{key}-#{msg}" do
        capture_stdout
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
        restore_stdout
      end
    end
    def it_should_raise_a_direct_error(value, kind, msg, &block)
      it "should raise an error #{kind}-#{value}-#{msg}" do
        capture_stdout
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
            fail "\ne2d\nshould have raised a #{kind} error for #{value} \n==#{e}"
          elsif FailFast.errors.length == 1 && !FailFast.errors.first.has_value_and_kind?(value, kind)
            fail "\ne2e\nshould have raised a #{kind.inspect} error for #{value.inspect}\n, but raised instead\n#{FailFast.errors.inspect}"
          elsif 2 <= FailFast.errors.length
            fail "\ne2f\nshould have raised only 1 #{kind} error for #{value}\nbut raised instead\n#{FailFast.errors.join("\n")}"
          end
        end
        restore_stdout
      end
    end

  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
    receiver.send :include, InstanceMethods
  end
end
Spec::Runner.configure do |config|
  config.include(DSLMacros)
end

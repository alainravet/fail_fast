
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

    def it_should_return_true(msg, &block)
      it "returns true #{msg}" do
        capture_stdout
        begin
          FailFast(SIMPLE_FILE_PATH).check.but_fail_later do
            raise "BUG : @@errorz should be empty \n#{errors.inspect}"  unless errors.empty?
            result = self.instance_eval(&block)
            #TODO : BETTER ERROR REPORTING
            result.should == true
          end
        rescue => e
          raise e
        end
        restore_stdout
      end
    end


    def it_should_return_false(msg, &block)
      it "returns false #{msg}" do
        capture_stdout
        begin
          FailFast(SIMPLE_FILE_PATH).check.but_fail_later do
            raise "BUG : @@errorz should be empty \n#{errors.inspect}"  unless errors.empty?
            result = self.instance_eval(&block)
            #TODO : BETTER ERROR REPORTING
            result.should == false
          end
        rescue => e
          raise e
        end
        restore_stdout
      end
    end

    def it_should_not_raise_an_error(msg, &block)
      it "does not raise an error #{msg}" do
        capture_stdout
        begin
          FailFast(SIMPLE_FILE_PATH).check do
            raise "BUG : @@errorz should be empty \n#{errors.inspect}"  unless errors.empty?
            self.instance_eval(&block)
          end
        rescue => e
          raise e
        ensure
          if FailFast.failed?
            fail "ZZshould not have raised an error, but it raised\n#{FailFast.global_errors.join("\n")}"
          end
        end
        restore_stdout
      end
    end

    def it_should_raise_an_error(key, kind, msg, &block)
      it "raises an error #{kind}-#{key}-#{msg}" do
        capture_stdout
        begin
          FailFast(SIMPLE_FILE_PATH).check do
            raise "BUG : @@errorz should be empty \n#{errors.inspect}"  unless errors.empty?
            self.instance_eval(&block)
          end
        rescue => e
          # uncomment the next line after the refactoring/once error are no longer raise
          #  raise e
        ensure
          if !FailFast.failed?
            fail "\ne2d\nshould have raised a #{kind} error for #{key} \n==#{e}"
          elsif FailFast.global_errors.length == 1 && !FailFast.global_errors.first.has_key_and_kind?(key, kind)
            fail "\ne2e\nshould have raised a #{kind.inspect} error for #{key.inspect}, but raised instead #{FailFast.global_errors.inspect}"
          elsif 2 <= FailFast.global_errors.length
            fail "\ne2f\nshould have raised only a #{kind} error for #{key}\n#{FailFast.global_errors.join("\n")}"
          end
        end
        restore_stdout
      end
    end
    def it_should_raise_a_direct_error(value, kind, msg, &block)
      it "raises an error #{kind}-#{value}-#{msg}" do
        capture_stdout
        begin
          FailFast(SIMPLE_FILE_PATH).check do
            raise "BUG : @@errorz should be empty \n#{errors.inspect}"  unless errors.empty?
            self.instance_eval(&block)
          end
        rescue => e
          # uncomment the next line after the refactoring/once error are no longer raise
          #  raise e
        ensure
          if !FailFast.failed?
            fail "\ne2d\nshould have raised a #{kind} error for #{value} \n==#{e}"
          elsif FailFast.global_errors.length == 1 && !FailFast.global_errors.first.has_value_and_kind?(value, kind)
            fail "\ne2e\nshould have raised a #{kind.inspect} error for #{value.inspect}\n, but raised instead\n#{FailFast.global_errors.inspect}"
          elsif 2 <= FailFast.global_errors.length
            fail "\ne2f\nshould have raised only 1 #{kind} error for #{value}\nbut raised instead\n#{FailFast.global_errors.join("\n")}"
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
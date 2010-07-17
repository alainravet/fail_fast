require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "check not linked to a config file" do
  before(:each) { capture_stdout }
  after( :each) { restore_stdout }


  it "should not raise an error when there are no checks" do
    lambda {
      FailFast().check do end
    }.should_not raise_error
    FailFast.failed?.should be_false
  end

  it "should raise an error when there is a failing check" do
    lambda {
      FailFast().check do
        fail 'error'
      end
    }.should raise_error(ExitTriggered)
    FailFast.failed?.should be_true
  end

  it "should raise a delayed error when there is a failing check" do
    lambda {
      FailFast().check_now.but_fail_later do
        fail 'error'
      end
    }.should_not raise_error
    lambda {
      FailFast.fail_now
    }.should raise_error(ExitTriggered)
    FailFast.global_errors.collect(&:kind).should == [:fail]
  end

end

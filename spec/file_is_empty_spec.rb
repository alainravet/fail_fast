require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ConfigCheck on an empty file" do
  before(:each) { capture_stdout }
  after( :each) { restore_stdout }


  it "should not raise an error when there are no checks" do
    lambda {
      FailFast(EMPTY_FILE_PATH).check do end
    }.should_not raise_error
    FailFast.failed?.should be_false
  end

  it "should raise an error when there is a failing check" do
    lambda {
      FailFast(EMPTY_FILE_PATH).check do
        has_value_for :anykey
      end
    }.should raise_error(ExitTriggered)
    FailFast.failed?.should be_true
  end

  it "should raise a delayed error when there is a failing check" do
    lambda {
      FailFast(EMPTY_FILE_PATH).check_now.but_fail_later do
        has_value_for :anykey
      end
    }.should_not raise_error
    lambda {
      FailFast.fail_now
    }.should raise_error(ExitTriggered)
    FailFast.global_errors.collect(&:kind).should == [:missing_value]
  end

end

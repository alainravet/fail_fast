require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ConfigCheck on an unknown file" do
  before(:all) { capture_stdout }
  after( :all) { restore_stdout }

  it "does not raise an error in new()" do
    FailFast(UNKNOWN_FILE_PATH)
    fail if FailFast.failed?
  end

  it "raises  an error in fail_fast()" do
    lambda {
      FailFast(UNKNOWN_FILE_PATH).check do end
    }.should raise_error(ExitTriggered)
    fail unless FailFast.global_errors.collect(&:kind) == [:config_file_not_found]
  end

end

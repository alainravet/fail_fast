require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ConfigCheck on an unknown file" do

  it "should not raise an error in new()" do
    FailFast.config_file(UNKNOWN_FILE_PATH)
  end

  it "should raise an error in fail_fast()" do
    lambda {
      FailFast.config_file(UNKNOWN_FILE_PATH).check do end
    }.should raise_error(FailFast::Error, /#{UNKNOWN_FILE_PATH}.*not.*found/)
  end

end

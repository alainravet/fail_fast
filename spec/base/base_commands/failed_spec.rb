require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'failed?' do
  example "is false when there are no errors" do
    FailFast(SIMPLE_FILE_PATH ).check_now.but_fail_later {}
    FailFast.failed?.should be_false
  end

  example "is true when there is 1 block and 1 error" do
    FailFast(UNKNOWN_FILE_PATH).check_now.but_fail_later {} # <-- 1 error here
    FailFast.failed?.should be_true
  end

  example "is true when the error block is followed by and error-free empty file block (BUG FIX)" do
    FailFast(UNKNOWN_FILE_PATH).check_now.but_fail_later {} # <-- 1 error here
    FailFast(EMPTY_FILE_PATH  ).check_now.but_fail_later {} #no errors in the last block
    FailFast.failed?.should be_true
  end
end
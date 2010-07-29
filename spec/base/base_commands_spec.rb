require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "fail()" do
  it_should_raise_a_direct_error('message-123', :fail, 'when fail() is called') {
    fail 'message-123'
  }
end

describe "only_if" do
  it_should_not_raise_an_error('only_if false does not run the block') {
    only_if false do
      fail 'never executed'
    end
  }

  it_should_raise_a_direct_error('message 456', :fail, 'only_if true runs the block') {
    only_if true do
      fail 'message 456'
    end
  }
end

describe "skip_if" do
  it_should_not_raise_an_error('skip_if(true) does not run the block') {
    skip_if true do
      fail 'never executed'
    end
  }

  it_should_raise_a_direct_error('message 456', :fail, 'skip_if(false) runs the block') {
    skip_if false do
      fail 'message 456'
    end
  }
end

describe "skip_if" do
  it_should_not_raise_an_error('skip_if(true) does not run the block') {
    skip_if true do
      fail 'never executed'
    end
  }

  it_should_raise_a_direct_error('message 456', :fail, 'skip_if(false) runs the block') {
    skip_if false do
      fail 'message 456'
    end
  }
end

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
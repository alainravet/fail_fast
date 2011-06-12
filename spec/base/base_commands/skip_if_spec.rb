require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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

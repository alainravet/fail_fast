require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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

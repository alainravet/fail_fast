require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "fail()" do
  it_should_raise_a_direct_error('message-123', :fail, 'when fail() is called') {
    fail 'message-123'
  }
end

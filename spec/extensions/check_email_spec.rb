require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'has_email_for()' do
  it_should_not_raise_an_error('when the value is an email') {
    has_email_for 'test/email'
  }
  it_should_raise_an_error('test/url', :not_an_email, 'when the value is not an email') {
    has_email_for 'test/url'
  }
  it_should_raise_an_error('invalid_key', :missing_value, 'when the key is invalid') {
    has_email_for 'invalid_key'
  }
end

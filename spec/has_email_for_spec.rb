require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'has_email_for()' do
  it_should_not_raise_an_error('when the value is an email') { has_email_for 'test/email' }
  it_should_raise_an_error('when the value is not an email', /value for.*is not an email/) { has_email_for 'test/url' }
  it_should_raise_an_error('when the key is invalid', /missing or blank value.*not_a_valid_key/) { has_email_for 'not_a_valid_key' }
end

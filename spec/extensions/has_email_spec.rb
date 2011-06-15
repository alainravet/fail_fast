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

  it "accepts a custom message for the 2 cases" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      has_email_for 'invalid_key', :message => 'a_custom_message'
      has_email_for 'test/url',    :message => 'a_custom_message_2'
    end
    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2)
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'has_email_for()' do
  it_should_not_raise_an_error('when the value is an email') {
    result = has_email_for 'test/email'
    result.should == true
  }
  it_should_raise_an_error('test/url', :not_an_email, 'when the value is not an email') {
    result = has_email_for 'test/url'
    result.should == false
  }
  it_should_raise_an_error('invalid_key', :missing_value, 'when the key is invalid') {
    result = has_email_for 'invalid_key'
    result.should == false
  }

  it "accepts a custom message for the 2 cases" do
    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      result = has_email_for 'invalid_key', :message => 'a_custom_message'
      result.should == false
      result = has_email_for 'test/url',    :message => 'a_custom_message_2'
      result.should == false
    end
    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2)
  end
end

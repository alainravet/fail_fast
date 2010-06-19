describe 'has_email_for()' do
  it_should_not_raise_an_error('when the value is an email') { has_email_for 'test/email' }
  it_should_raise_an_error('when the value is not an email', /value for.*is not an email/) { has_email_for 'test/url' }
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'has_url_for()' do
before(:all) do
    FakeWeb.register_uri(:get, "http://example.com/index.html", :body => "I'm reachable!")
    FakeWeb.register_uri(:get, "http://localhost/index.html"  , :body => "I'm reachable!")
    FakeWeb.register_uri(:get, "http://example.com"           , :body => "I'm reachable!")
  end

  it_should_not_raise_an_error('when the value is an url') { has_url_for 'test/url' }
  it_should_not_raise_an_error("when the domain is 'localhost'") { has_url_for 'test/url_localhost' }
  it_should_raise_an_error('test/email', :not_a_url, 'when the value is not an url') { has_url_for 'test/email' }

  it_should_raise_an_error('not_a_valid_key', :missing_value ,'when the value is blank or absent') { has_url_for 'not_a_valid_key' }

  it_should_not_raise_an_error('when the url is reachable') {
    has_url_for 'test/url_reachable'    , :reachable => true, :may_add_trailing_slash => true
  }
  it_should_raise_an_error('test/url_not_reachable', :url_not_reachable ,'when the url is not reachable') {
    has_url_for 'test/url_not_reachable', :reachable => true
  }
end

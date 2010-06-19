require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "typical usage" do

  example 'simple usage (short notation)' do
    FailFast(SIMPLE_FILE_PATH).check do
      has_value_for :first_key
      has_values_for :last_key, 'number_six', :letter_x
      has_value_for 'test/mongoDB/database'             # composed key


      has_value_for :last_key, /(premier|dernier)/      # regexp match

      has_url_for 'test/url'
      has_url_for 'test/url_reachable', :reachable => true, :may_add_trailing_slash => true

      has_email_for 'test/email'

      has_mongoDB_for 'test/mongoDB'
      has_mongoDB_for 'test/unknown_mongoDB_db', :check_database  => false

      directory_exists_for  'test/a_directory'
      file_exists_for       'test/a_file'
    end
  end

  example 'with a keys yaml prefix' do
    rails_env_prefix = 'test' # == Rails.env
    FailFast(SIMPLE_FILE_PATH, rails_env_prefix).check do
      has_value_for 'mongoDB/database'             # composed key
    end
  end

  before(:each) { fake_the_remote_services() }
end

def fake_the_remote_services
  FakeWeb.register_uri(:get, "http://example.com/index.html", :body => "I'm reachable!")
  FakeWeb.register_uri(:get, "http://localhost/index.html", :body => "I'm reachable!")
  FakeWeb.register_uri(:get, "http://example.com", :body => "I'm reachable!")

  conn = Mongo::Connection.new
  conn.should_receive(:database_names).any_number_of_times.and_return %w(sample_mongoDB)
  Mongo::Connection.should_receive(:new).any_number_of_times.and_return(conn)
end

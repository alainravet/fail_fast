require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'the key prefix' do

  example 'works fine in all the checkers' do
    stub_request(:get, "http://localhost:3200").to_return(:body => "I'm reachable!")

    conn = Mongo::Connection.new
    conn.should_receive(:database_names).any_number_of_times.and_return %w(sample_mongoDB)
    Mongo::Connection.should_receive(:new).and_return(conn)

    arconn = Object.new
    arconn.should_receive(:active?).and_return(true)
    ActiveRecord::Base.should_receive(:connection).and_return(arconn)

    FailFast(SIMPLE_FILE_PATH, 'test').check do
      has_value_for             'email'
      has_email_for             'email'
      has_url_for               'url'
      directory_exists_for      'a_directory'
      file_exists_for           'a_file'
      has_mongoDB               'mongoDB'
      has_active_record_db_for  'db_connection'
      is_on_path_for            'app_on_path'
    end
  end
end
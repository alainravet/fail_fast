require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'has_ar_db' do
  context '' do
    it_should_not_raise_an_error('when the connections succeeds' ) {
      conn = Object.new ; conn.should_receive(:active?).and_return(true)
      ActiveRecord::Base.should_receive(:connection).and_return(conn)

      result = has_active_record_db :host => 'localhost', :adapter => 'mysql', :database=> 'a-db', :username => 'root'
      result.should == true
    }

    it_should_raise_a_direct_error('ze-error-message', :active_record_db_connection_error, 'when the connection fails' ) {
      exception = StandardError.new('ze-error-message')
      ActiveRecord::Base.should_receive(:establish_connection).and_raise(exception)

      result = has_active_record_db valid_connection_options = {}
      result.should == false
    }
  end

  context '_for' do
    it_should_not_raise_an_error('when the connections succeeds' ) {
      conn = Object.new ; conn.should_receive(:active?).and_return(true)
      ActiveRecord::Base.should_receive(:connection).and_return(conn)

      result = has_active_record_db_for 'db_connection'
      result.should == true
    }

    it_should_raise_an_error('db_connection', :active_record_db_connection_error, 'when the connection fails' ) {
      exception = StandardError.new('an-error-message')
      ActiveRecord::Base.should_receive(:establish_connection).and_raise(exception)

      result = has_active_record_db_for 'db_connection'
      result.should == false
    }

    it_should_raise_an_error('invalid_key', :missing_value, 'when the key is invalid' ) {
      result = has_active_record_db_for 'invalid_key'
      result.should == false
    }
  end

  it "accepts a custom message for those 3 cases" do
    exception = StandardError.new('an-error-message')
    ActiveRecord::Base.should_receive(:establish_connection).twice.and_raise(exception)

    FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
      has_active_record_db_for 'invalid_key',  :message => 'a_custom_message'
      has_active_record_db_for 'db_connection',  :message => 'a_custom_message_2'
      has_active_record_db valid_connection_options = {},  :message => 'a_custom_message_3'
    end
    messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
    messages.should =~ %w(a_custom_message a_custom_message_2 a_custom_message_3)
  end

end
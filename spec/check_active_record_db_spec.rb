require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'has_ar_db' do
  context '' do
    it_should_not_raise_an_error('when the connections succeeds' ) {
      conn = Object.new ; conn.should_receive(:active?).and_return(true)
      ActiveRecord::Base.should_receive(:connection).and_return(conn)

      has_active_record_db :host => 'localhost', :adapter => 'mysql', :database=> 'a-db', :username => 'root'
    }

    it_should_raise_a_direct_error('ze-error-message', :active_record_db_connection_error, 'when the connection fails' ) {
      exception = StandardError.new('ze-error-message')
      ActiveRecord::Base.should_receive(:establish_connection).and_raise(exception)

      has_active_record_db valid_connection_options = {}
    }
  end

  context '_for' do
    it_should_not_raise_an_error('when the connections succeeds' ) {
      conn = Object.new ; conn.should_receive(:active?).and_return(true)
      ActiveRecord::Base.should_receive(:connection).and_return(conn)

      has_active_record_db_for 'db_connection'
    }

    it_should_raise_an_error('db_connection', :active_record_db_connection_error, 'when the connection fails' ) {
      exception = StandardError.new('an-error-message')
      ActiveRecord::Base.should_receive(:establish_connection).and_raise(exception)

      has_active_record_db_for 'db_connection'
    }

    it_should_raise_an_error('invalid_key', :missing_value, 'when the key is invalid' ) {
      has_active_record_db_for 'invalid_key'
    }
  end
end
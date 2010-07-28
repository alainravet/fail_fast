require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'has_mongoDB' do

  context '' do
    context 'when the mongo server cannot be reached' do
      before(:each) { Mongo::Connection.should_receive(:new).any_number_of_times.and_raise(Mongo::ConnectionFailure) }

      it_should_raise_a_direct_error('localhost', :mongoDB_server_not_found, 'when the mongoDB server connection failed') {
        has_mongoDB 'localhost'
      }

      it "should accept a custom message for this case" do
        FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
          has_mongoDB 'localhost',  :message => 'a_custom_message'
          has_mongoDB 'localhost',  :timeout => 1, :message => 'a_custom_message_2'
        end
        messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
        messages.should =~ %w(a_custom_message a_custom_message_2)
      end
    end

    context 'when the mongo server can be reached' do
      before(:each) do
        conn = Mongo::Connection.new
        conn.should_receive(:database_names).any_number_of_times.and_return %w(sample_mongoDB)
        Mongo::Connection.should_receive(:new).and_return(conn)
      end

      it_should_not_raise_an_error('when the mongoDB server responds'                         ) { has_mongoDB 'localhost'                   }
      it_should_not_raise_an_error('when the mongoDB server responds and the db can be found' ) { has_mongoDB 'localhost', 'sample_mongoDB' }

      it_should_raise_a_direct_error('not_a_known_db', :mongoDB_db_not_found, 'when the database cannot be found on the mongoDB') {
        has_mongoDB 'localhost', 'not_a_known_db'
      }
      it "should accept a custom message for this case" do
        FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
          has_mongoDB 'localhost', 'not_a_known_db',  :message => 'a_custom_message'
        end
        messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
        messages.should =~ %w(a_custom_message)
      end
    end
  end

  context '_for' do
    context 'when the mongo server cannot be reached' do
      before(:each) { Mongo::Connection.should_receive(:new).any_number_of_times.and_raise(Mongo::ConnectionFailure) }

      it_should_raise_an_error('test/unreachable_mongoDB_server', :mongoDB_server_not_found, 'when the mongoDB server connection failed') {
        has_mongoDB_for 'test/unreachable_mongoDB_server'
      }
      it_should_raise_an_error('not_a_valid_key', :missing_value, 'when the key is invalid') { has_mongoDB_for 'not_a_valid_key' }
      it "should accept a custom message for those 2 cases" do
        FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
          has_mongoDB_for 'not_a_valid_key',                  :message => 'a_custom_message'
          has_mongoDB_for 'test/unreachable_mongoDB_server',  :message => 'a_custom_message_2'
        end
        messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
        messages.should =~ %w(a_custom_message a_custom_message_2)
      end
    end

    context 'when the mongo server can be reached' do
      before(:each) do
        conn = Mongo::Connection.new
        conn.should_receive(:database_names).any_number_of_times.and_return %w(sample_mongoDB)
        Mongo::Connection.should_receive(:new).and_return(conn)
      end

      it_should_not_raise_an_error('when the mongoDB server responds and the database can be found') {
        has_mongoDB_for 'test/mongoDB'
      }

      it_should_raise_an_error('test/unknown_mongoDB_db', :mongoDB_db_not_found,'when the database cannot be found on the mongoDB') {
        has_mongoDB_for 'test/unknown_mongoDB_db'
      }
      it "should accept a custom message for this case" do
        FailFast(SIMPLE_FILE_PATH).check_now.but_fail_later do
          has_mongoDB_for 'test/unknown_mongoDB_db',  :message => 'a_custom_message'
        end
        messages = FailFast.errors_db.errors_for(FailFast.errors_db.keys.first).collect { |e| e.message }
        messages.should =~ %w(a_custom_message)
      end

      it_should_not_raise_an_error('when :ignore_database => false desactivate the db check') {
        has_mongoDB_for 'test/unknown_mongoDB_db', :check_database => false
      }
    end
  end
end

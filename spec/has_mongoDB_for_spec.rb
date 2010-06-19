describe 'has_mongoDB_for()' do

  context 'when the mongo server cannot be reached' do
    before(:each) { Mongo::Connection.should_receive(:new).and_raise(Mongo::ConnectionFailure) }

    it_should_raise_an_error('when the mongoDB server connection failed', /mongoDB.*test\/unreachable_mongoDB_server.*not/) {
      has_mongoDB_for 'test/unreachable_mongoDB_server'
    }
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

    it_should_raise_an_error('when the database cannot be found on the mongoDB', /mongoDB.*unknown_mongoDB_db.*test\/unknown_mongoDB_db.*not/) {
      has_mongoDB_for 'test/unknown_mongoDB_db'
    }

    it_should_not_raise_an_error('when :ignore_database => false desactivate the db check') {
      has_mongoDB_for 'test/unknown_mongoDB_db', :check_database => false
    }
  end
end

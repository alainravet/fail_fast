require 'active_record'
# ActiveRecord::Base.establish_connection(
#    :adapter  => "mysql",
#    :host     => "localhost",
#    :username => "myuser",
#    :password => "mypass",
#    :database => "somedatabase"
# )
# ActiveRecord::Base.establish_connection(
#    :adapter => "sqlite",
#    :database  => "path/to/dbfile"
#  )
# ActiveRecord::Base.establish_connection(
#    :adapter => "sqlite3",
#    :dbfile  => ":memory:"
#)

class FailFast
  module CheckActiveRecordDB

    # Ensure the ActiveRecord connection can be established :
    #
    # Usage :
    #   has_active_record_db :host => 'localhost', :adapter => 'sqlite3', :database=> 'prod_db'
    #
    def has_active_record_db(*params)
      options = params.last.is_a?(Hash) ? params.pop : {}
      begin
        ActiveRecord::Base.establish_connection(options)
        @connection = ActiveRecord::Base.connection
        @success    = @connection && @connection.active?
      rescue => e
        @success        = false
        @error_message  = e.message
      end
      unless @success
        FailFast.errors << ErrorDetails.new(nil, :active_record_db_connection_error, @error_message)
      end
    end

    # Ensure the ActiveRecord connection can be established :
    #
    # Usage :
    #   has_active_record_db_for  'production/database'
    #
    def has_active_record_db_for(key, *params)
      return unless has_value_for key
      return unless has_value_for "#{key}/adapter"
      return unless has_value_for "#{key}/database"

      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      begin
        connection_options = p.value
        ActiveRecord::Base.establish_connection(connection_options)
        @connection = ActiveRecord::Base.connection
        @success    = @connection && @connection.active?
      rescue => e
        @success        = false
        @error_message  = e.message
      end
      unless @success
        FailFast.errors << ErrorDetails.new(key, :active_record_db_connection_error, @error_message)
      end
    end

  end
end

FailFast.send  :include, FailFast::CheckActiveRecordDB

__END__
    # Ensure the mongoDB server can be reached, and the db could be opened :
    #
    # Usage :
    #  has_mongoDB_for 'test/mongoDB'
    #  has_mongoDB_for 'test/unknown_mongoDB_db', :check_database => false
    #
    def has_mongoDB_for(key, *params)
      return unless has_value_for key
      return unless has_value_for "#{key}/host"
      return unless has_value_for "#{key}/database"

      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      value = value_for_deep_key(key)
      host, port, db = value['host'], value['port'], value['database']

      begin
        @conn = Mongo::Connection.new(host, port)
      rescue Mongo::ConnectionFailure
        FailFast.errors << ErrorDetails.new(key, :mongoDB_server_not_found, host)
        return
      end

      must_check_db = !(false == options[:check_database])
      if must_check_db && !@conn.database_names.include?(db)
        FailFast.errors << ErrorDetails.new(key, :mongoDB_db_not_found, db)
      end
    end

  end
end



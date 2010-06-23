class FailFast
  module CheckMongoDB

    # Ensure the mongoDB server can be reached, and the db could be opened :
    #
    # Usage :
    #  has_mongoDB 'localhost'
    #  has_mongoDB 'localhost', 'my_db', :port => 1234, :timeout => 2
    #  has_mongoDB 'localhost', :port => 1234, :timeout => 2
    #
    def has_mongoDB(host, *params)
      options = params.last.is_a?(Hash) ? params.pop : {}
      db      = params.first

      begin
        port = options.delete(:port)
        @conn = Mongo::Connection.new(host, port, options)
      rescue Mongo::ConnectionFailure
        FailFast.errors << ErrorDetails.new(nil, :mongoDB_server_not_found, host)
        return
      end

      if db && !@conn.database_names.include?(db)
        FailFast.errors << ErrorDetails.new(nil, :mongoDB_db_not_found, db)
      end
    end

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

FailFast.send  :include, FailFast::CheckMongoDB

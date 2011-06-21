class FailFast
  module HasMongoDB

    # Ensure the mongoDB server can be reached, and the db could be opened :
    #
    # Usage :
    #  has_mongoDB 'localhost'
    #  has_mongoDB 'localhost', :message => 'custom message'
    #  has_mongoDB 'localhost', 'my_db', :port => 1234, :timeout => 2
    #  has_mongoDB 'localhost', :port => 1234, :timeout => 2, :message => 'custom message'
    #
    def has_mongoDB(host, *params)
      options = params.last.is_a?(Hash) ? params.pop : {}
      db      = params.first

      begin
        port = options.delete(:port)
        @conn = Mongo::Connection.new(host, port, options)
      rescue Mongo::ConnectionFailure
        add_error ErrorDetails.new(nil, :mongoDB_server_not_found, host, options[:message])
        return false
      end

      failure = db && !@conn.database_names.include?(db)
      if failure
        add_error ErrorDetails.new(nil, :mongoDB_db_not_found, db, options[:message])
      end
      !failure
    end

    # Ensure the mongoDB server can be reached, and the db could be opened :
    #
    # Usage :
    #  has_mongoDB_for 'test/mongoDB'
    #  has_mongoDB_for 'test/unknown_mongoDB_db', :check_database => false
    #
    def has_mongoDB_for(key, *params)
      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options
      return false unless has_value_for key              , :message => options[:message]
      return false unless has_value_for "#{key}/host"    , :message => options[:message]
      return false unless has_value_for "#{key}/database", :message => options[:message]


      value = value_for_deep_key(key)
      host, port, db = value['host'], value['port'], value['database']

      begin
        @conn = Mongo::Connection.new(host, port)
      rescue Mongo::ConnectionFailure
        add_error ErrorDetails.new(key, :mongoDB_server_not_found, host, options[:message])
        return false
      end

      must_check_db = !(false == options[:check_database])
      failure = must_check_db && !@conn.database_names.include?(db)
      if failure
        add_error ErrorDetails.new(key, :mongoDB_db_not_found, db, options[:message])
      end
      !failure
    end

  end
end

FailFast.send  :include, FailFast::HasMongoDB

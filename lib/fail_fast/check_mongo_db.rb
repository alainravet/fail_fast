class FailFast
  module CheckMongoDB

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
        @errors << "  - the mongoDB server for #{key.to_s} could not be reached."
        return
      end

      must_check_db = !(false == options[:check_database])
      if must_check_db && !@conn.database_names.include?(db)
        @errors << "  - the mongoDB #{db} for #{key.to_s} could not be found."
      end
    end

  end
end

FailFast.send  :include, FailFast::CheckMongoDB

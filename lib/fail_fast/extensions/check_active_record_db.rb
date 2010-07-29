require 'active_record'

class FailFast
  module CheckActiveRecordDB

    # Ensure the ActiveRecord connection can be established :
    #
    # Usage :
    #   has_active_record_db :host => 'localhost', :adapter => 'sqlite3', :database=> 'prod_db'
    #   has_active_record_db :host => 'localhost', :adapter => 'sqlite3', :database=> 'prod_db', :message => 'custom message'
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
        add_error ErrorDetails.new(nil, :active_record_db_connection_error, @error_message, options[:message])
      end
    end

    # Ensure the ActiveRecord connection can be established :
    #
    # Usage :
    #   has_active_record_db_for  'production/database'
    #   has_active_record_db_for  'production/database', :message => 'custom message'
    #
    def has_active_record_db_for(raw_key, *params)
      p = key_value_regexp_options(raw_key, params)
      key, options = p.key, p.options
      return unless has_value_for raw_key              , :message => options[:message]
      return unless has_value_for "#{raw_key}/adapter" , :message => options[:message]
      return unless has_value_for "#{raw_key}/database", :message => options[:message]

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
        add_error ErrorDetails.new(key, :active_record_db_connection_error, @error_message, options[:message])
      end
    end

  end
end

FailFast.send  :include, FailFast::CheckActiveRecordDB

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

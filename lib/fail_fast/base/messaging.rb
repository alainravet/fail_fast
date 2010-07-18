class FailFast

  module Messaging

    def default_message_for(e)
      c_value   = vcol(e.value)
      qc_value  = "'#{vcol(e.value)}'"
      qc_key    = "'#{kcol(e.key)}'"
      details = if    e.value.nil? then " for the key #{qc_key}"
                elsif e.key.nil?   then " #{qc_value}"
                else  " #{qc_value} for the key #{qc_key}"
                end

      case e.kind
        when :config_file_not_found
          mcol("The config file could not be found") + " : #{yellow(e.value)}."
        when :missing_value
          mcol("Missing value") +" #{details}."
        when :value_does_not_match
          mcol("Invalid value") +" #{details}."
        when :not_an_email
          mcol("Invalid email address") + " #{details}."
        when :not_a_url
          mcol("Invalid url") + " #{details}."
        when :url_not_reachable
          mcol("Could not reach the url") + " #{details}."
        when :directory_not_found
          mcol("Missing directory") + " #{details}."
        when :file_not_found
          mcol("Missing file") + " #{details}."
        when :not_on_path
          mcol("App not on path : ") + " #{details}."
        when :mongoDB_server_not_found
          mcol("Could not connect to the mongoDb server") + " #{details}."
        when :mongoDB_db_not_found
          mcol("Could not open the mongoDb db") + " #{details}."
        when :active_record_db_connection_error
          mcol("Could not connect to the DB server") + " #{details}."
        when :fail
          mcol(e.value)
        else
          "%-38s %-35s %-30s \n" % [ e.kind, e.key, qc_value]
      end
    end

    def mcol(msg)   lred(msg) end
    def kcol(key) yellow(key) end
    def vcol(val) yellow(val) end

  end
end

FailFast.send  :include, FailFast::Messaging

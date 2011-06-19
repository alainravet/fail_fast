module FailFast::ErrorReporter
  class Base
    include FailFast::ConsoleUtils

    protected

      def default_message_for(e, use_color=true)
        @use_color = use_color
        qc_value  = "'#{vcol(e.value)}'"
        qc_key    = "'#{kcol(e.key)}'"
        details = if    e.value.nil? then " for the key #{qc_key}"
                  elsif e.key.nil?   then " #{qc_value}"
                  else  " #{qc_value} for the key #{qc_key}"
                  end

        s = case e.kind
          when :config_file_not_found             then mcol("The config file could not be found") + " : #{yellow(e.value)}."
          when :missing_value                     then mcol("Missing value") +" #{details}."
          when :value_does_not_match              then mcol("Invalid value") +" #{details}."
          when :not_an_email                      then mcol("Invalid email address") + " #{details}."
          when :not_a_url                         then mcol("Invalid url") + " #{details}."
          when :url_not_reachable                 then mcol("Could not reach the url") + " #{details}."
          when :directory_not_found               then mcol("Missing directory") + " #{details}."
          when :file_not_found                    then mcol("Missing file") + " #{details}."
          when :not_on_path                       then mcol("App not on path : ") + " #{details}."
          when :mongoDB_server_not_found          then mcol("Could not connect to the mongoDb server") + " #{details}."
          when :mongoDB_db_not_found              then mcol("Could not open the mongoDb db") + " #{details}."
          when :active_record_db_connection_error then mcol("Could not connect to the DB server") + " #{details}."
          when :fail                              then mcol(e.value)
          else
            "%-38s %-35s %-30s \n" % [ e.kind, e.key, qc_value]
        end
        e.message ? "#{e.message}\n| #{s}": s
      end

      def mcol(msg) @use_color ?   lred(msg) : msg end
      def kcol(key) @use_color ? yellow(key) : key end
      def vcol(val) @use_color ? yellow(val) : val end
  end
end
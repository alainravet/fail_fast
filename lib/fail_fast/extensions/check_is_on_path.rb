class FailFast
  module CheckIsOnPath

    # Ensure the application is on the path
    #
    # Usage
    #   is_on_path 'jruby'
    #
    def is_on_path(app, *params)
      unless found_on_the_path(app)
        add_error ErrorDetails.new(nil, :not_on_path, app)
      end
    end

    # Ensure the key value can be found on the path
    #
    # Usage
    #   is_on_path_for 'file_compressor'
    #
    def is_on_path_for(key, *params)
      return unless has_value_for key

      p = key_value_regexp_options(key, params)

      key = p.key
      app   = value_for_deep_key(key)

      unless found_on_the_path(app)
        add_error ErrorDetails.new(key, :not_on_path, app)
      end
    end

  private
    def found_on_the_path(app)
      `which #{app}` =~ /#{app}$/
    end
  end
end

FailFast.send  :include, FailFast::CheckIsOnPath
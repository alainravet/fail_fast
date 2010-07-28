class FailFast
  module CheckIsOnPath

    # Ensure the application is on the path
    #
    # Usage
    #   is_on_path 'jruby'
    #   is_on_path 'jruby', :message => 'custom message'
    #
    def is_on_path(app, options = {})
      unless found_on_the_path(app)
        add_error ErrorDetails.new(nil, :not_on_path, app, options[:message])
      end
    end

    # Ensure the key value can be found on the path
    #
    # Usage
    #   is_on_path_for 'file_compressor'
    #   is_on_path_for 'file_compressor', :message => 'custom message'
    #
    def is_on_path_for(key, options = {})
      return unless has_value_for key, :message =>  options[:message]
      app   = value_for_deep_key(key)

      unless found_on_the_path(app)
        add_error ErrorDetails.new(key, :not_on_path, app, options[:message])
      end
    end

  private
    def found_on_the_path(app)
      `which #{app}` =~ /#{app}$/
    end
  end
end

FailFast.send  :include, FailFast::CheckIsOnPath
class FailFast
  module FileExists

    # Ensure the value is an existing file
    #
    # Usage
    #   file_exists '~/.bash_profile'
    #   file_exists '~/.bash_profile', :message => 'custom message'
    #
    def file_exists(path, options={})
      success = File.exists?(path) && File.file?(path)
      unless success
        add_error ErrorDetails.new(nil, :file_not_found, path, options[:message])
      end
      success
    end

    # Ensure the key value is an existing file exists
    #
    # Usage
    #   file_exists_for 'foo/config/app.yml'
    #   file_exists_for 'foo/config/app.yml', :message => 'custom message'
    #
    def file_exists_for(raw_key, *params)
      p = key_value_regexp_options(raw_key, params)
      key, options = p.key, p.options

      return false unless has_value_for raw_key, :message => options[:message]

      path = value_for_deep_key(key)
      success = File.exists?(path) && File.file?(path)
      unless success
        add_error ErrorDetails.new(key, :file_not_found, p.value, options[:message])
      end
      success
    end

  end
end

FailFast.send  :include, FailFast::FileExists
class FailFast
  module CheckFileSystem

    # Ensure the value is an existing directory
    #
    # Usage
    #   directory_exists '/tmp'
    #
    def directory_exists(path, *params)
      unless File.exists?(path) && File.directory?(path)
        add_error ErrorDetails.new(nil, :directory_not_found, path)
      end
    end

    # Ensure the value is an existing file
    #
    # Usage
    #   file_exists '~/.bash_profile'
    #
    def file_exists(path, *params)
      unless File.exists?(path) && File.file?(path)
        add_error ErrorDetails.new(nil, :file_not_found, path)
      end
    end

    # Ensure the key value is an existing directory
    #
    # Usage
    #   directory_exists_for 'foo/config'
    #
    def directory_exists_for(key, *params)
      return unless has_value_for key

      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      path = value_for_deep_key(key)

      unless File.exists?(path) && File.directory?(path)
        add_error ErrorDetails.new(key, :directory_not_found, p.value)
      end
    end

    # Ensure the key value is an existing file exists
    #
    # Usage
    #   file_exists_for 'foo/config/app.yml'
    #
    def file_exists_for(key, *params)
      return unless has_value_for key

      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      path = value_for_deep_key(key)

      unless File.exists?(path) && File.file?(path)
        add_error ErrorDetails.new(key, :file_not_found, p.value)
      end
    end

  end
end

FailFast.send  :include, FailFast::CheckFileSystem
class FailFast
  module CheckFileSystem

    # Ensure the value is an existing directory
    #
    # Usage
    #   directory_exists '/tmp'
    #   directory_exists '/tmp', :message => 'custom message'
    #
    def directory_exists(path, options={})
      unless File.exists?(path) && File.directory?(path)
        add_error ErrorDetails.new(nil, :directory_not_found, path, options[:message])
      end
    end

    # Ensure the value is an existing file
    #
    # Usage
    #   file_exists '~/.bash_profile'
    #   file_exists '~/.bash_profile', :message => 'custom message'
    #
    def file_exists(path, options={})
      unless File.exists?(path) && File.file?(path)
        add_error ErrorDetails.new(nil, :file_not_found, path, options[:message])
      end
    end

    # Ensure the key value is an existing directory
    #
    # Usage
    #   directory_exists_for 'foo/config'
    #   directory_exists_for 'foo/config', :message => 'custom message'
    #
    def directory_exists_for(key, *params)
      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      return unless has_value_for key, :message => options[:message]

      path = value_for_deep_key(key)
      unless File.exists?(path) && File.directory?(path)
        add_error ErrorDetails.new(key, :directory_not_found, p.value, options[:message])
      end
    end

    # Ensure the key value is an existing file exists
    #
    # Usage
    #   file_exists_for 'foo/config/app.yml'
    #   file_exists_for 'foo/config/app.yml', :message => 'custom message'
    #
    def file_exists_for(key, *params)
      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      return unless has_value_for key, :message => options[:message]

      path = value_for_deep_key(key)
      unless File.exists?(path) && File.file?(path)
        add_error ErrorDetails.new(key, :file_not_found, p.value, options[:message])
      end
    end

  end
end

FailFast.send  :include, FailFast::CheckFileSystem
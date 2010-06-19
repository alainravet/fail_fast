class FailFast
  module CheckFileSystem

    # Ensure the directory exists (and is a directory)
    #
    # Usage
    #   directory_exists_for 'foo/config'
    #
    def directory_exists_for(key, *params)
      has_value_for key

      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      path = value_for_deep_key(key)

      unless File.exists?(path) && File.directory?(path)
        @errors << "  - directory  #{path.inspect} does not exist"
      end
    end

    # Ensure the file exists (and is a file)
    #
    # Usage
    #   file_exists_for 'foo/config/app.yml'
    #
    def file_exists_for(key, *params)
      has_value_for key

      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      path = value_for_deep_key(key)

      unless File.exists?(path) && File.file?(path)
        @errors << "  - file  #{path.inspect} does not exist"
      end
    end

  end
end

FailFast.send  :include, FailFast::CheckFileSystem
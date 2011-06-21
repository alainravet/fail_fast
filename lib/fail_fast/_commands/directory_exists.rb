class FailFast
  module DirectoryExists

    # Ensure the value is an existing directory
    #
    # Usage
    #   directory_exists '/tmp'
    #   directory_exists '/tmp', :message => 'custom message'
    #
    def directory_exists(path, options={})
      success = File.exists?(path) && File.directory?(path)
      unless success
        add_error ErrorDetails.new(nil, :directory_not_found, path, options[:message])
      end
      success
    end

    # Ensure the key value is an existing directory
    #
    # Usage
    #   directory_exists_for 'foo/config'
    #   directory_exists_for 'foo/config', :message => 'custom message'
    #
    def directory_exists_for(raw_key, *params)
      p = key_value_regexp_options(raw_key, params)
      key, options = p.key, p.options

      return false unless has_value_for raw_key, :message => options[:message]

      path = value_for_deep_key(key)
      success = File.exists?(path) && File.directory?(path)
      unless success
        add_error ErrorDetails.new(key, :directory_not_found, p.value, options[:message])
      end
      success
    end

  end
end

FailFast.send  :include, FailFast::DirectoryExists
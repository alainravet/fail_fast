class FailFast
  class ErrorDb
    def initialize
      @@hash = {}
    end

    def errors_for(key)
      @@hash[key] ||= []
    end

    def append(key, value)
      errors_for(key)  << value
    end

    def keys
      @@hash.keys
    end

    def self.key_for(config_file_path, keys_prefix=nil)
      ["<#{config_file_path}>", keys_prefix].compact.join
    end

    def messages
      @@hash.first[1]
    end
  end
end

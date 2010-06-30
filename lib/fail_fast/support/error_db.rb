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
  end
end

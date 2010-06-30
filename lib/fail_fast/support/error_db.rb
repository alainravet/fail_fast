class FailFast
  class ErrorDb
    def initialize
      @@hash = {}
    end

    def errors_for(filter)
      @@hash[filter] ||= []
    end

    def append(filter, value)
      errors_for(filter)  << value
    end
  end
end

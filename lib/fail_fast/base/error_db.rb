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


# ONLY USED BY TESTS !!
class FailFast::ErrorDb
  def global_data
    errors_for(@@hash.keys.first)
  end
end

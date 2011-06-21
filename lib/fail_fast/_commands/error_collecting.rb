class FailFast
  module ErrorCollecting

    def self.included(base)
      base.extend(ClassMethods)
    end


# ------------------------------ Instance methods -------------------------------

    def add_error(value)
      self.class.errors_db.append(@errors_key, value)
    end

    def errors
      self.class.errors_db.errors_for(@errors_key)
    end

  end
end

# -------------------------------- Class methods --------------------------------
class FailFast
  module ErrorCollecting::ClassMethods

    def errors_db #:nodoc:
      @@_errors_db ||= FailFast::ErrorDb.new
    end

  end
end


FailFast.send  :include, FailFast::ErrorCollecting
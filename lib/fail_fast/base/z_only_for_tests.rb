# ONLY USED BY TESTS !!
class FailFast
  def self.global_errors  #:nodoc:
    @@_errors_db.global_data
  end

  def self.reset_error_db!  #:nodoc:
    @@_errors_db = ErrorDb.new
  end
end
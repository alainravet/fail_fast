# ONLY USED BY TESTS !!
class FailFast
  def self.global_errors
    @@_errors_db.global_data
  end

  def self.reset_error_db!
    @@_errors_db = ErrorDb.new
  end
end
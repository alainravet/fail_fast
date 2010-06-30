# ONLY USED BY TESTS !!
class FailFast::ErrorDb
  def global_data
    errors_for(@@hash.keys.first)
  end
end

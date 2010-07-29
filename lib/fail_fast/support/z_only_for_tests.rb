# ONLY USED BY TESTS !!
class FailFast::ErrorDb
  def global_data
    @@hash.keys.collect {|key|errors_for(key)}.flatten
  end
end

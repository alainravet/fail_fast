class FailFast::ErrorDetails < Struct.new(:key, :kind, :value)

  def has_key_and_kind?(akey, akind)
    (key.to_s == akey.to_s) && kind.to_sym == akind.to_sym
  end

  def has_value_and_kind?(avalue, akind)
    (value.to_s == avalue.to_s) && kind.to_sym == akind.to_sym
  end
end

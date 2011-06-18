class FailFast::ErrorDetails

  attr_reader :key, :kind, :value, :message

  def initialize(key, kind, value=nil, message=nil)
    @key, @kind, @value, @message = key, kind, value, message
  end

  def ==(other)
    self.key == other.key && self.kind == other.kind && self.value == other.value && self.message == other.message
  end

  def has_key_and_kind?(akey, akind) #:nodoc:
    (key.to_s == akey.to_s) && kind.to_sym == akind.to_sym
  end

  def has_value_and_kind?(avalue, akind) #:nodoc:
    (value.to_s == avalue.to_s) && kind.to_sym == akind.to_sym
  end
end

class FailFast

  ERB_TEMPLATE = File.dirname(__FILE__) + '/../report.txt.erb'

  class Error < StandardError
  end

  class ErrorDetails < Struct.new(:key, :kind, :value) ;
    def has_key_and_kind?(akey, akind)
      (key.to_s == akey.to_s) && kind.to_sym == akind.to_sym
    end
    def has_value_and_kind?(avalue, akind)
      (value.to_s == avalue.to_s) && kind.to_sym == akind.to_sym
    end
  end
end


class FailFast
  module Errors

  private
    def raise_and_print_errors
      @errors = FailFast.errors
      raise "\n\n\n" + ERB.new(File.read(ERB_TEMPLATE)).result(binding) + "\n\n"
    end

  end
end

FailFast.send  :include, FailFast::Errors
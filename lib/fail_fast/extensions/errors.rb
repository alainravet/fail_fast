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
    def print_errors_and_exit
      @errors = FailFast.errors
      puts "\n\n\n" + ERB.new(File.read(ERB_TEMPLATE)).result(binding) + "\n\n"
      exit
    end

  end
end

FailFast.send  :include, FailFast::Errors
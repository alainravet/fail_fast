class FailFast

  class Params < Struct.new(:key, :value, :regexp, :options) ; end

  module Utils

    def blank?(value)
      value.nil? || (value.is_a?(String) && '' == value.strip)
    end

    # Usage
    #   value_for_deep_key('one/two/three')
    # returns
    #   @yaml_config_as_hash['one']['two']['three']
    #
    def value_for_deep_key(key)
      key.to_s.split('/').inject(@yaml_config_as_hash) { |h, k| h[k] } rescue nil
    end


    def key_value_regexp_options(key, params)
      last = params.pop
      if last.is_a?(Hash)
        options = last
      else
        params << last
        options = {}
      end

      last = params.pop
      if last.is_a?(Regexp)
        regexp = last
      else
        params << last
      end

      key = "#{@keys_prefix}/#{key}" if @keys_prefix
      value = value_for_deep_key(key)

      Params.new(key, value, regexp, options)
    end

    NO_COLOUR="\033[0m"
    RED      ="\033[31m"
    LRED      ="\033[1;31m"
    BLUE     ="\033[34m"
    GREEN    ="\033[32m"
    YELLOW   ="\033[1;33m"

    def red(   str) [RED,    str, NO_COLOUR].join  end
    def lred(   str) [LRED,    str, NO_COLOUR].join  end
    def blue(  str) [BLUE,   str, NO_COLOUR].join  end
    def green( str) [GREEN,  str, NO_COLOUR].join  end
    def yellow(str) [YELLOW, str, NO_COLOUR].join  end
  end
end

FailFast.send  :include, FailFast::Utils

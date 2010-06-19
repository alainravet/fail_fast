class FailFast
  module CheckValue

    # Usage
    #  has_value_for 'str_key'
    #  has_value_for :sym_key, /localhost/
    # returns
    #   true if succesful, false otherwise
    def has_value_for(key, *params)
      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      nof_errors = @errors.size
      if blank?(p.value)
        @errors << "  - missing or blank value for : #{key.to_s}"

      elsif p.regexp
        @errors << "  - value for #{key.to_s} does not match #{p.regexp.inspect}" unless p.value =~ p.regexp

      elsif hash?(options) && range?(options[:in])
        @errors << "  - value for #{key.to_s} not in range #{options[:in].inspect}" unless options[:in].include?(p.value)

      elsif hash?(options) && array?(options[:in])
        @errors << "  - value for #{key.to_s} not in array #{options[:in].inspect}" unless options[:in].include?(p.value)
      end
      no_new_error = nof_errors == @errors.size
    end

    # Usage
    #  has_values_for :sym_key, 'str_key'
    #
    def has_values_for(*keys)
      keys.each{|key| has_value_for(key)}
    end

  end
end
FailFast.send  :include, FailFast::CheckValue
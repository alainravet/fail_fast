class FailFast
  module CheckValue

    # Usage
    #  has_values_for :sym_key, 'str_key'
    #
    def has_values_for(*keys)
      keys.each{|key| has_value_for(key)}
    end


    # Usage
    #  has_value_for 'str_key'
    #  has_value_for :sym_key, /localhost/
    # returns
    #   true if succesful, false otherwise
    def has_value_for(key, *params)
      p = key_value_regexp_options(key, params)
      key, options = p.key, p.options

      nof_errors = errors.size
      if blank?(p.value)
        add_error ErrorDetails.new(key, :missing_value, nil)

      elsif p.regexp
        add_error ErrorDetails.new(key, :value_does_not_match, p.value) unless p.value =~ p.regexp

      elsif options.is_a?(Hash) && options[:in].is_a?(Range)
        add_error ErrorDetails.new(key, :value_not_in_range,   p.value) unless options[:in].include?(p.value)

      elsif options.is_a?(Hash) && options[:in].is_a?(Array)
        add_error ErrorDetails.new(key, :value_not_in_array,   p.value) unless options[:in].include?(p.value)
      end
      no_new_error = nof_errors == errors.size
    end

  end
end

FailFast.send  :include, FailFast::CheckValue
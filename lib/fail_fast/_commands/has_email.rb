class FailFast

  module HasEmail
    # Usage
    #  has_email_for 'test/admin_email'
    #
    def has_email_for(raw_key, *params)
      p = key_value_regexp_options(raw_key, params)
      key, options = p.key, p.options

      return false unless has_value_for raw_key, :message =>  options[:message]

      value = value_for_deep_key(key)
      failure = EmailValidator.invalid_email_address?(value)
      if failure
        add_error ErrorDetails.new(key, :not_an_email, value, options[:message])
      end
      !failure
    end
  end

  module EmailValidator #:nodoc:
    VALID_EMAIL_ADDRESS_REGEXP = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/

    def self.valid_email_address?(email)
      email.strip!
      !!(email =~ VALID_EMAIL_ADDRESS_REGEXP)
    end

    def self.invalid_email_address?(email)
      !valid_email_address?(email)
    end
  end
end

FailFast.send  :include, FailFast::HasEmail
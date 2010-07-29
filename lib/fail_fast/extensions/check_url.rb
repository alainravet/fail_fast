class FailFast

  module CheckUrl
    # Usage
    #   test if the url is valid :
    #     has_url_for 'test/server_url'
    #   test if the url is reachable :
    #     has_url_for 'test/server_url', :reachable => true
    #   test if the url is reachable, possibly after adding a trailing slash.
    #   (ex: http://example.com  + http://example.com/)
    #     has_url_for 'test/server_url', :reachable => true, :may_add_trailing_slash => true
    #
    def has_url_for(raw_key, *params)
      p = key_value_regexp_options(raw_key, params)
      key, options = p.key, p.options
      return unless has_value_for raw_key, :message =>  options[:message]

      value = value_for_deep_key(key)
      if UrlValidator.invalid_url?(value)
        add_error ErrorDetails.new(key, :not_a_url, value, options[:message])
        return
      end
      if true==options.delete(:reachable) && UrlValidator.unreachable_url?(value, options)
        add_error ErrorDetails.new(key, :url_not_reachable, value, options[:message])
      end
    end
  end

  module UrlValidator #:nodoc:
    IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255
    VALID_URL_REGEXP = %r{
      \A
      https?://                                                    # http:// or https://
      ([^\s:@]+:[^\s:@]*@)?                                        # optional username:pw@
      ( (([^\W_]+\.)*xn--)?[^\W_]+([-.][^\W_]+)*\.[a-z]{2,6}\.? |  # domain (including Punycode/IDN)...
          #{IPv4_PART}(\.#{IPv4_PART}){3} |                        # or IPv4
          localhost )                                              # or localhost
      (:\d{1,5})?                                                  # optional port
      ([/?]\S*)?                                                   # optional /whatever or ?whatever
      \Z
    }iux

    def self.valid_url?(url)
      url.strip!
      !!(url =~ VALID_URL_REGEXP)
    end

    def self.invalid_url?(url)
      !valid_url?(url)
    end

    def self.reachable_url?(url_s, options = {:may_add_trailing_slash => false})
      url_s = "http://#{url_s}" unless url_s =~ /http/
      url   = URI.parse(url_s)
      http  = Net::HTTP.new(url.host, url.port)
      http.open_timeout = http.read_timeout = 5 #seconds
      http.get(url.path)
      true
    rescue Exception
      can_retry_after_appending_a_fwd_slash = (true == options[:may_add_trailing_slash]) && !(url_s =~ /\/$/)
      can_retry_after_appending_a_fwd_slash ?
        reachable_url?(url_s + '/', options) :
        false
    end

    def self.unreachable_url?(url_s, options = {:may_add_trailing_slash => false})
      !reachable_url?(url_s, options)
    end
  end
end

FailFast.send  :include, FailFast::CheckUrl
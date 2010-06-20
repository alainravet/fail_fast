require 'yaml'
require 'erb'

class FailFast
  ERB_TEMPLATE = File.dirname(__FILE__) + '/report.txt.erb'

  class Error < StandardError ; end
  class ErrorDetails < Struct.new(:key, :kind, :value) ;
    def has_key_and_kind?(akey, akind)
      (key.to_s == akey.to_s) && kind.to_sym == akind.to_sym
    end
    def has_value_and_kind?(avalue, akind)
      (value.to_s == avalue.to_s) && kind.to_sym == akind.to_sym
    end
  end
  class Params < Struct.new(:key, :value, :regexp, :options) ; end

  def initialize(path, prefix=nil)
    @path   = path
    @prefix = prefix
    @@errors = []
  end

  def self.errors
    @@errors
  end

  def check(&block)
    if missing_file?(@path)
      FailFast.errors << ErrorDetails.new(nil, :config_file_not_found, @path)
    else
      @hash = YAML.load(ERB.new(File.read(@path)).result) || {}
      self.instance_eval(&block)
    end
    raise_and_print_errors if errors?
  end


private

  def blank?( value)        value.nil? || value.is_a?(String) && ''==value.strip  end
  def range?( value)        value.is_a?(Range )                                   end
  def regexp?(value)        value.is_a?(Regexp)                                   end
  def array?( value)        value.is_a?(Array )                                   end
  def hash?(  value)        value.is_a?(Hash)                                     end
  def missing_file?(path)  !File.exist?(path)                                     end

  # Usage
  #   value_for_deep_key('one/two/three')
  # returns
  #   @hash[:one][:two][:three]
  #
  def value_for_deep_key(key)
    key.to_s.split('/').inject(@hash) { |h, k| h[k] } rescue nil
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

    key = "#{@prefix}/#{key}" if @prefix
    value = value_for_deep_key(key)

    Params.new(key, value, regexp, options)
  end

  def errors?
    !FailFast.errors.empty?
  end


  def raise_and_print_errors
    @errors = @@errors 
    raise "\n\n\n" + ERB.new(File.read(ERB_TEMPLATE)).result(binding) + "\n\n"
  end
end

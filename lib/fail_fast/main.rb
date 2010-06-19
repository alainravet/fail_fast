require 'yaml'
require 'erb'

class FailFast
  class Error < StandardError ; end
  class Params < Struct.new(:key, :value, :regexp, :options) ; end

  def initialize(path, prefix=nil)
    @path   = path
    @prefix = prefix
    @errors = []
  end

  def self.config_file(path, prefix=nil)
    new(path, prefix)
  end

  def check(&block)
    if missing_file?(@path)
      @errors << "The file #{@path} could not be found."
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
    !@errors.empty?
  end


  def raise_and_print_errors
    text = @errors.join("\n")
    raise Error.new(text)
  end
end

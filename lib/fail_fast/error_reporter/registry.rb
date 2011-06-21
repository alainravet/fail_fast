module FailFast::ErrorReporter
  class Registry
    @@registry = {}

    def self.register(klass)
      @@registry[klass.to_sym] = klass
    end

    def self.get(key)
      @@registry[key]
    end

  end

end

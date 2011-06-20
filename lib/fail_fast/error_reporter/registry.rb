module FailFast::ErrorReporter
  class Registry
    @@registry = {}

    def self.register(key, value)
      @@registry[key] = value
    end

    def self.get(key)
      @@registry[key]
    end

  end

end

module DiggoClipper
  class Config
    CONFIG_PATH = File.join(GEM_LIB_DIR, GEM_NAME, "config", "config.yml")

    def self.[](key)
      key = key.to_s if key.is_a? Symbol
      @config[key]
    end

    # note that key yielded is string,
    # it's better to use enumerator though
    def self.each
      if block_given?
        @config.each { |key, val| yield(key, val) }
      else
        @config.enum_for
      end
    end

    def self.size
      @config.size
    end

    def self.length
      @config.length
    end

    def self.validate
      # empty for now
    end

    def self.process
      @config["browser"] = @config["browser"].to_sym
    end

    private_class_method :new, :validate, :process

    @config = YAML.load(File.read(CONFIG_PATH))
    validate
    process
  end
end

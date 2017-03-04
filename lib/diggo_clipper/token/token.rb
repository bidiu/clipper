module DiggoClipper
  class Token
    TOKEN_DIR = File.join(GEM_LIB_DIR, GEM_NAME, "token")
    ACCESS_FILE = File.join(TOKEN_DIR, Config[:access_token_file])
    REFRESH_FILE = File.join(TOKEN_DIR, Config[:refresh_token_file])

    def self.save_access_token(token)
      f = File.new(ACCESS_FILE, "w")
      f.puts token.to_json
      f.close
    end

    def self.load_access_token
      if File.file? ACCESS_FILE
        JSON.parse(File.read(ACCESS_FILE), symbolize_names: true)
      end
    end

    def self.save_refresh_token(token)
      f = File.new(REFRESH_FILE, "w")
      f.puts token.to_json
      f.close
    end

    def self.load_refresh_token
      if File.file? REFRESH_FILE
        JSON.parse(File.read(REFRESH_FILE), symbolize_names: true)
      end
    end

    # TODO clear tokens

    private_class_method :new
  end
end

module DiggoClipper
  class OneNote
    include OAuth

    def initialize(driver)
      @driver = driver
    end

    def ensure_privileges
      access_token
    end

    def create_note(html)
      acc_token = access_token[:access_token]
      # upload logic
      puts acc_token
    end
  end
end

module DiggoClipper
  class DriverFactory
    # construct a new driver
    def self.create
      @vendor_path ||= File.join(GEM_LIB_DIR, GEM_NAME, "vendor", VENDOR_LIB_NAME)
      opt = {
        chrome_options: {
          extensions: [ Base64.strict_encode64(File.open(@vendor_path, "rb").read) ]
        }
      }
      Selenium::WebDriver.for BROWSER,
              desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(opt)
    end
  end
end

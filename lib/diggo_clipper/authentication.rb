module DiggoClipper
  # authentication for only Diigo
  class Authentication
    include Helper

    LOGIN_URL = "https://www.diigo.com/sign-in"
    VENDOR_OPTION_URL = "chrome-extension://pnhplgjpclknigjpccbcnmicgcieojbh/options.html"

    def initialize(driver)
      @driver = driver
    end

    def login
      @driver.navigate.to LOGIN_URL
      rand_sleep
      inputs = @driver.find_elements(:css, ".loginArea .input input")
      inputs[0].send_keys Config[:email]
      inputs[1].send_keys Config[:password]
      @driver.find_element(:css, ".submitArea button").click
      close_popups
      disable_autoload
    end
  private
    def close_popups
      skip_btn = async_element :css, ".Guide .skip", abort_on_timeout: false
      skip_btn.click if skip_btn
      close_btn = async_element :class, "modalCloseButton", abort_on_timeout: false
      close_btn.click if close_btn
    end

    def disable_autoload
      @driver.navigate.to VENDOR_OPTION_URL
      @driver.find_element(:css, "label[for=check-autoload]").click
    end
  end
end

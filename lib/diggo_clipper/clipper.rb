module DiggoClipper
  class Clipper
    include Helper

    def initialize(driver)
      @driver = driver
    end

    def start
      pages_to_clip = Config[:pages_to_clip]

      @driver.navigate.to pages_to_clip[0]
      # TODO ensure all requests completed
      to_absolute_url
      if @driver.execute_script Js[:range]
        trigger_extension
      else
        # TODO failed to create selection
      end
    end
  private
    def close_premium_popup
      close_btn = async_element(:id, "diigo-premium-close", abort_on_timeout: false)
      close_btn.click if close_btn
    end

    # return the unique id (actually a class) of this highlight
    def trigger_extension
      @driver.find_element(:id, "diigolet-csm-highlight-wrapper").click
      close_premium_popup
    end
  end
end

module DiggoClipper
  module Helper
  private
    def to_new_window
    	@driver.switch_to.window @driver.window_handles[-1]
    end

    def rand_sleep
      duration = rand * (Config[:suspend_max] - Config[:suspend_min] + 1) + Config[:suspend_min]
      sleep duration.to_i
    end

    # times - max retry times
    # timeout - timeout for async request
    # abort_on_timeout - when failing to get the async element, whether abort
    # code block - event to wait
    # return
    #   true - success
    #   false - fail
    def wait_async_request(times, timeout, abort_on_timeout)
    	raise ArgumentError, "'times' and 'timeout' have to be >= 1" if times < 1 or timeout < 1

    	1.upto(times) do |t|
    		begin
    			wait = Selenium::WebDriver::Wait.new timeout: timeout
    			wait.until { yield }
    			return true
    		rescue Selenium::WebDriver::Error::TimeOutError
          if t >= times
            if abort_on_timeout
              abort "Request timeout - consider increasing the value of 'request_timeout'."
            else
              return false
            end
          end
    			puts "Request timeouts, retry - #{t}/#{times}.."
    		end
    	end
    end

    # return the async element, return nil if failed
    def async_element(selector_type, selector, times: 1, timeout: Config[:timeout], abort_on_timeout: true)
    	loaded = wait_async_request(times, timeout, abort_on_timeout) do
    		@driver.find_elements(selector_type, selector).size > 0
    	end
    	@driver.find_element(selector_type, selector) if loaded
    end

    # return the async element, return empty array if failed
    def async_elements(selector_type, selector, times: 1, timeout: Config[:timeout], abort_on_timeout: true)
      wait_async_request(times, timeout, abort_on_timeout) do
    		@driver.find_elements(selector_type, selector).size > 0
    	end
      @driver.find_elements(selector_type, selector)
    end

    def set_attribute(element, attr_name, attr_value)
      @driver.execute_script(
        "arguments[0].setAttribute(arguments[1], arguments[2])",
        element, attr_name, attr_value
      );
    end

    def get_attribute(element, attr_name)
      @driver.execute_script(
        "return arguments[0].getAttribute(arguments[1])",
        element, attr_name
      );
    end

    def domain
      @driver.execute_script("return document.domain")
    end

    # not including trailing slash
    def base_url
      return "http://#{get_domain}"
    end

    # including trailing slash
    def cur_url_path
      url = @driver.current_url
      last_slash = url.rindex('/')
      url[0..last_slash]
    end

    # currently only for img, a, script, and link tags
    # arugments MUST be symbols
    def to_absolute_url(*tag_names)
      @all_supported ||= [:img, :a, :script, :link]
      @attr_map ||= {
        img: "src",
        a: "href",
        script: "src",
        link: "href"
      }

      tag_names ||= all_supported
      if tag_names.any? { |tag_name| not @all_supported.include?(tag_name) }
        raise ArgumentError, "Only support img, a, script and link tags"
      end

      tag_names.each do |tag_name; attr_name|
        attr_name = @attr_map[tag_name]
        elements = @driver.find_elements(:tag_name, tag_name)

        elements.each do |element; attr_value|
          attr_value = get_attribute(element, attr_name)

          if attr_value.start_with? '/'
            set_attribute(element, attr_name, base_url + attr_value)
          elsif attr_value.start_with? '.'
            set_attribute(element, attr_name, cur_url_path + attr_value)
          end
        end
      end
    end

  end
end

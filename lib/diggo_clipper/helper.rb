module DiggoClipper
  module Helper
    def to_new_window
    	@driver.switch_to.window @driver.window_handles[-1]
    end

    def rand_sleep
    	duration = rand * (DiggoClipper::SUSPEND_MAX - DiggoClipper::SUSPEND_MIN + 1) + DiggoClipper::SUSPEND_MIN
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

    # return the async element, if failed, return nil
    def async_element(selector_type, selector, times: 1, timeout: TIMEOUT, abort_on_timeout: true)
    	loaded = wait_async_request(times, timeout, abort_on_timeout) do
    		@driver.find_elements(selector_type, selector).size > 0
    	end
    	@driver.find_element(selector_type, selector) if loaded
    end
  end
end

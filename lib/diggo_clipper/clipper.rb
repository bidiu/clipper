module DiggoClipper
  class Clipper
    include Helper

    def initialize(driver)
      @driver = driver
      @onenote = OneNote.new(driver)
    end

    def start
      @onenote.ensure_privileges
      DiggoClipper::Authentication.new(@driver).login

      pages_to_clip = Config[:pages_to_clip]

      @driver.navigate.to pages_to_clip[0]
      # TODO ensure all requests completed
      to_absolute_url
      if selected_text = @driver.execute_script(Js['range_selection'])
        trigger_extension(selected_text)
      end
      @onenote.create_note(@driver.page_source)
    end

  private
    def close_premium_popup
      close_btn = async_element(:id, "diigo-premium-close", abort_on_timeout: false)
      close_btn.click if close_btn
    end

    def trigger_extension(selected_text)
      selected_text = selected_text.gsub(/\s+/, '')
      sleep Config[:wait_threshold]
      async_element(:id, "diigolet-csm-highlight-wrapper").click
      # close premium popup, if any
      close_premium_popup
      rand_sleep

      hl_id = nil
      found = false
      tmp_selected_text = String.new(selected_text)
      async_elements(:css, "em.diigoHighlight").each do |em|
        if matched = /id_\w+/.match(get_attribute(em, "class"))
          cur_hl_id = matched.to_s
          if hl_id.nil?
            hl_id = cur_hl_id
          elsif hl_id != cur_hl_id
            hl_id = cur_hl_id
            tmp_selected_text = String.new(selected_text)
          end
          em_text = em.text.strip.gsub(/\s+/, '')
          tmp_selected_text.slice!(em_text)
          if (1 - tmp_selected_text.length / selected_text.length.to_f) > Config[:match_threshold]
            found = true
            break
          end
        end
      end

      if found
        element = @driver.find_elements(:css, "em.#{hl_id}").first
        @driver.action.move_to(element).perform
        sleep Config[:wait_threshold]
        del_btn = @driver.find_element(:id, "diigolet-annMenu-del")
        del_btn.click if del_btn
      end
    end

  end
end

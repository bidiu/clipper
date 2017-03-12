module DiggoClipper
  class OneNote
    include OAuth
    include HttpHelper

    # OneNote REST API endpoints
    LIST_NOTEBOOKS_ENDPOINT = 'https://www.onenote.com/api/v1.0/me/notes/notebooks'
    LIST_SECTIONS_ENDPOINT = "https://www.onenote.com/api/v1.0/me/notes/notebooks/%s/sections"


    def initialize(driver)
      @driver = driver
    end

    def ensure_notebook
      ensure_privileges
      if notebook.nil?
        abort 'The OneNote notebook you specified doesn\'t exist. Please check that.'
      end
    end

    def create_note(html)
      puts section
      # upload logic following
    end

  private
    def ensure_privileges
      access_token
    end

    # return a JSON, with id and name keys
    # if filed, return nil
    def notebook
      return @notebook if @notebook

      resp = HTTP
          .headers(authorization: "Bearer #{access_token[:access_token]}")
          .get(LIST_NOTEBOOKS_ENDPOINT, params: {
            select: 'id,name',
            filter: "name eq '#{Config[:notebook]}'"
          })
      if resp.code.to_s.start_with? '2'
        json = response_body(resp)
        @notebook = JSON.parse(json, symbolize_names: true)[:value].first
      end
      return @notebook
    end

    # return a JSON, with id and name keys
    # if filed, return nil
    def section
      return @section if @section

      resp = HTTP
          .headers(authorization: "Bearer #{access_token[:access_token]}")
          .get(LIST_SECTIONS_ENDPOINT % notebook[:id], params: {
            select: 'id,name',
            filter: "name eq '#{Config[:section]}'"
          })
      if resp.code.to_s.start_with? '2'
        json = response_body(resp)
        @section = JSON.parse(json, symbolize_names: true)[:value].first
      end
      return @section
    end

  end
end

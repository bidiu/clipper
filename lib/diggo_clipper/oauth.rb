module DiggoClipper
  # an util class
  class UrlParams
    include Enumerable

    def initialize(url)
      @params = {}
      CGI::parse(URI(url).query).each do |name, values|
        name = name.to_sym
        if values.empty?
          @params[name] = nil
        elsif values.size == 1
          @params[name] = values[0]
        else
          @params[name] = values
        end
      end
    end

    def each
      @params.each do |name, value|
        yield(name, value)
      end
    end

    def [](name)
      name = name.to_sym if name.is_a? String
      @params[name]
    end
  end


  module OAuth
    # return a json hash
    def access_token
      if (acc_token = Token.load_access_token) && (not token_expire?(acc_token))
        return acc_token
      end

      au_token = auth_token
      resp = HTTP.headers(content_type: 'application/x-www-form-urlencoded')
            .post(Config[:token_url],
              body: sprintf(Config[:token_url_body], au_token, Config[:redirect_uri]) )

      if resp.code == 200
        json = ''
        while buf = resp.body.readpartial(Config[:buf_size])
          json << buf
        end
        acc_token = JSON.parse(json, symbolize_names: true)
        Token.save_access_token(acc_token)
        return acc_token
      else
        puts "response: \n#{resp}"
        abort "Failed to get priviledges from OneNote. HTTP Code: #{resp.code}."
      end
    end

    # TODO add logic for failure
    # return the auth token itself
    def auth_token
      @driver.navigate.to(Config[:auth_url])
      loop do
        url = @driver.current_url
        if url.start_with? Config[:redirect_uri]
          params = UrlParams.new(url)
          return params[:code]
        end
        sleep Config[:wait_threshold]
      end
    end

    def token_expire?(token)
      # TODO
      false
    end
  end

end

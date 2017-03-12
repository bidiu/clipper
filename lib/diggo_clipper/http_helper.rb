# helper file
module DiggoClipper
  module HttpHelper

    def response_body(resp)
      body = ''
      while buf = resp.body.readpartial(Config[:buf_size])
        body << buf
      end
      return body
    end

  end
end

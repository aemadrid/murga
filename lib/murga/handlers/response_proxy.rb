module Murga
  module Handler
    class Base
      class ResponseProxy

        java_import 'ratpack.http.Status'

        attr_reader :response

        def initialize(response)
          @response = response
        end

        delegate :cookie, :cookies, :headers, to: :response

        def set_headers(new_headers = {})
          new_headers.each { |k, v| headers.set k.to_s, v.to_s }
        end

        def send_body(body)
          response.send body
        end

        def to_s
          "#<#{self.class.name} status=#{response.get_status} headers=#{headers.inspect}>"
        end

        alias :inspect :to_s

      end
    end
  end
end


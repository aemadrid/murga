module Murga
  module Handler
    class Basic < Murga::Handler::Base

      def after_request(result)
        return if finalized?

        case result
        when String
          render body: result
          :string
        when Hash
          send_json result
          :hash
        else
          :skipped
        end
      end

      def send_json(hsh)
        render content_type: JSON_CONTENT_TYPE, body: JrJackson::Json.dump(hsh)
      end

    end
  end
end

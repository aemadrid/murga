module Murga
  module Handler
    class Rack < Base

      def self.config(options = {})
        @app = options[:app]
      end

      def self.app
        @app
      end

      def process_request
        rack_status, rack_headers, rack_body = process_rack_app
        render status: rack_status.to_i,
               headers: rack_headers,
               body: rack_body.join('')
      end

      def process_rack_app
        self.class.app.call(env)
      rescue ::Exception => e
        logger.error "Exception: #{e.class.name} : #{e.message} : \n  #{e.backtrace[0, 10].join("\n  ")}"
        return [500, {}, []]
      end

      def env
        @env ||= Hash.new.tap do |hsh|
          hsh.update request_env
          hsh.update rack_env
          hsh.update extra_env
        end
      end

      private

      def request_env
        {
          'REQUEST_METHOD' => request.method_name,
          'SCRIPT_NAME'    => '',
          'PATH_INFO'      => request.path,
          'QUERY_STRING'   => request.query,
          'SERVER_NAME'    => request.host,
          'SERVER_PORT'    => request.port,
        }
      end

      def rack_env
        {
          'rack.version'      => ::Rack.version.split('.'),
          'rack.errors'       => STDERR,
          'rack.multithread'  => true,
          'rack.multiprocess' => false,
          'rack.run_once'     => false,
          'rack.input'        => rack_body,
          'rack.url_scheme'   => request.scheme,
          'rack.hijack?'      => false,
        }
      end

      def extra_env
        {

        }
      end

      def rack_body
        @rack_body ||= StringIO.new(request.body.to_s).set_encoding('ASCII-8BIT')
      end

    end
  end
end

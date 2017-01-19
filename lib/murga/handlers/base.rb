require_relative '../handlers/request_proxy'
require_relative '../handlers/response_proxy'

module Murga
  module Handler
    class Base

      java_import 'ratpack.exec.Promise'
      java_import 'ratpack.exec.Blocking'
      java_import 'ratpack.http.Response'

      DEFAULT_RESPONSE_STATUS = 200
      JSON_CONTENT_TYPE       = 'application/json;charset=UTF-8'

      class << self

        def handle(context)
          new.handle context
        end

        attr_writer :logger

        def logger
          @logger || Server.logger
        end

      end

      def initialize
        @finalized = false
      end

      attr_reader :context, :request, :response_headers
      attr_accessor :response_status

      delegate :params, to: :request

      def handle(context)
        setup_request context

        if handles_request?
          run_request
        else
          context.next
        end
      end

      def process_request
        raise "You must implement #process_request in #{self.class.name}"
      end

      def handles_request?
        true
      end

      def render(options = {})
        response = get_response options[:status] || response_status

        update_headers response, options
        render_body response, options

        @finalized = true
      end

      def redirect(*args)
        context.redirect *args

        @finalized = true
      end

      def finalized?
        !!@finalized
      end

      private

      def setup_request(context)
        @context          = context
        @request          = RequestProxy.new context.request
        @response_status  = DEFAULT_RESPONSE_STATUS
        @response_headers = {}
      end

      def run_request
        result = process_request
        send(:after_request, result) if respond_to? :after_request
      rescue ::Exception => e
        run_exception(e)
      end

      def run_exception(e)
        msg = "Exception: #{e.class.name} : #{e.message}"
        logger.error msg + "\n  " + e.backtrace[0,10].join("\n  ")
        render status: 500, body: msg
      end

      def get_response(code)
        ResponseProxy.new context.get_response.status(code.to_i)
      end

      def update_headers(response, options)
        response_headers.merge options[:headers] || {}
        response_headers['Content-Type'] = options[:content_type] if options[:content_type]
        response.set_headers response_headers
      end

      def render_body(response, options)
        body = options[:body] || ''
        response.send_body body
      end

      def logger
        self.class.logger
      end

    end
  end
end

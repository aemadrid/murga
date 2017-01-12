module Murga
  module Handler
    class Base

      java_import 'ratpack.exec.Promise'
      java_import 'ratpack.exec.Blocking'

      DEFAULT_STATUS    = 200
      JSON_CONTENT_TYPE = 'application/json;charset=UTF-8'

      def self.handle(context)
        new.handle(context)
      end

      attr_reader :context

      delegate :request, :response, :redirect, to: :context
      delegate :get_body, :get_method, to: :request
      delegate :is_get?, :is_head?, :is_patch?, :is_post?, :is_put?, to: :get_method
      delegate :send_file, to: :response

      def initialize(context = nil)
        @context   = context
        @finalized = false
      end

      def handle(context = nil)
        @context = context unless context.nil?
        if handles_request?
          result = process_request
          process_result(result) unless finalized?
        else
          context.next
        end
      end

      def process_result(result)
        case result
        when String
          render result
        when Hash
          send_json result
        else
          render result.to_s
        end
      end

      def process_request
        raise "You must implement #process_request in #{self.class.name}"
      end

      def handles_request?
        true
      end

      def halt(status, body = '', headers = {})
        response.status status
        set_headers headers
        render body
      end

      def set_headers(headers = {})
        headers.each { |k, v| response.headers[k.to_s] = v.to_s }
      end

      def render(*args)
        context.render *args
        @finalized = true
      end

      def finalize(*args)
        response.send *args
        @finalized = true
      end

      def redirect(*args)
        context.redirect *args
        @finalized = true
      end

      def finalized?
        !!@finalized
      end

      def body
        @body ||= get_body { |x| @body = x.to_s }
      end

      def send_json(hsh)
        finalize JSON_CONTENT_TYPE, JrJackson::Json.dump(hsh)
      end

      def params
        @params ||= build_params
      end

      private

      def build_params
        ActiveSupport::HashWithIndifferentAccess.new.tap do |hsh|
          hsh.update params_from_query
          hsh.update params_from_tokens
          hsh.update params_from_headers
        end
      end

      def params_from_query
        request.query_params.to_h
      end

      def params_from_tokens
        context.path_tokens.to_h
      end

      def params_from_headers
        Hash.new.tap do |hsh|
          forwarded       = request.headers.get('X-Forwarded-For')
          hsh[:remote_ip] = forwarded if forwarded.present?
        end
      end

    end
  end
end

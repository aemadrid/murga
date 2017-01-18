module Murga
  module Handler
    class Base
      class RequestProxy

        attr_reader :request

        def initialize(request)
          @request = request
          @body    = :uninitialized
        end

        def body
          return @body unless @body == :uninitialized

          @body = request.get_body.then { |str| @body = str }
          sleep 0.01 while @body == :uninitialized
          @body
        end

        delegate :content_length, :content_type, :cookies,
                 :path, :protocol, :query, :query_params, :raw_uri, :uri,
                 :is_ajax_request, :is_chunked_transfer, :one_cookie,
                 to: :request

        alias :is_ajax? :is_ajax_request
        alias :is_chunked? :is_chunked_transfer
        alias :cookie :one_cookie

        def request_method
          request.getMethod
        end

        delegate :is_get?, :is_head?, :is_patch?, :is_post?, :is_put?, to: :request_method

        def method_name
          request_method.getName
        end

        def headers
          request.headers
        end

        def params
          @params ||= build_params
        end

        def remote_address
          request.remote_address.to_s
        end

        def host
          request.remote_address.host_text
        end

        def port
          request.remote_address.port
        end

        def scheme
          protocol.split('/').first.downcase
        end

        def to_s
          "#<#{self.class.name} path=#{path.inspect} query=#{query.inspect} params=#{params.inspect} headers=#{headers.inspect}>"
        end

        alias :inspect :to_s

        private

        def build_params
          ActiveSupport::HashWithIndifferentAccess.new.tap do |hsh|
            hsh.update params_from_query
            hsh.update params_from_headers
          end
        end

        def params_from_query
          query_params.to_h
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
end
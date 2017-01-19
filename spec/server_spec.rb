require 'spec_helper'

module Murga
  describe Server do
    let(:path) { EXAMPLE1_ROOT }
    let(:host) { '0.0.0.0' }
    let(:port) { find_open_port }
    let(:handlers) { [] }
    let(:options) { { base_dir: path.to_s, host: host, port: port, handlers: handlers } }
    let(:server) { described_class.new options }
    let(:index_body) { file 'public/index.html' }
    context 'vanilla' do
      context 'config' do
        it 'works' do
          expect(server.config).to be_a Config
          expect(server.config.base_dir.to_s).to eq path.to_s
          expect(server.config.host).to eq host
          expect(server.config.port).to eq port
        end
      end
      context 'requests' do
        it 'handles all known types' do
          while_running_server do
            expect_response '/', 200, index_body
            expect_response '/index.html', 200, index_body, 'Content-Type' => 'text/html'
            expect_response '/missing', 404
          end
        end
      end
    end
    context 'dynamic' do
      let(:handlers) { [Testing::SimpleHandler, Testing::ExtraHandler, Testing::PostHandler] }
      context '+ public' do
        let(:path) { EXAMPLE1_ROOT }
        context 'requests' do
          it 'handles all known types' do
            while_running_server do
              # Dynamic
              expect_response '/halt_404', 404, ''
              expect_response '/halt_500', 500, 'Something went wrong'
              expect_response '/error', 500, 'Exception: RuntimeError : missing'
              expect_response '/error?msg=hello', 500, 'Exception: RuntimeError : hello'
              expect_response '/extra', 200, 'Hello from extra!'
              expect_response '/posting', 404, '', {}
              expect_response '/posting', 200, 'Hello from posting!', {}, method: :post
              # JSON
              expect_json_response '/params'
              expect_json_response '/params?a=1', 'a' => '1'
              expect_json_response '/params?a=1&b=2', 'a' => '1', 'b' => '2'
              # Static
              expect_response '/', 200, index_body
              expect_response '/index.html', 200, index_body, 'Content-Type' => 'text/html'
              expect_response '/missing', 404
            end
          end
        end
      end
      context '+ no public' do
        let(:path) { EXAMPLE3_ROOT }
        context 'requests' do
          it 'handles all known types' do
            while_running_server do
              # Dynamic
              expect_response '/', 200, 'Hello from root!'
              expect_response '/halt_404', 404, ''
              expect_response '/halt_500', 500, 'Something went wrong'
              expect_response '/extra', 200, 'Hello from extra!'
              # JSON
              expect_json_response '/params'
              expect_json_response '/params?a=1', 'a' => '1'
              expect_json_response '/params?a=1&b=2', 'a' => '1', 'b' => '2'
              # Static
              expect_response '/index.html', 404
              expect_response '/missing', 404
            end
          end
        end
      end
    end
    context 'basic rack' do
      let(:msg) { 'Hello from Rack!' }
      let(:rack_app) { Proc.new { |_| ['200', {}, [msg]] } }
      let(:server) { described_class.new(options).tap { |x| x.add_rack_handler rack_app } }
      context '+ public' do
        let(:path) { EXAMPLE1_ROOT }
        context 'requests' do
          it 'handles all known types' do
            while_running_server do
              # Rack
              expect_response '/any', 200, msg
              expect_response '/other', 200, msg
              # Static
              expect_response '/', 200, index_body
              expect_response '/index.html', 200, index_body, 'Content-Type' => 'text/html'
            end
          end
        end
      end
      context '+ no public' do
        let(:path) { EXAMPLE3_ROOT }
        context 'requests' do
          it 'handles all known types' do
            while_running_server do
              # Rack
              expect_response '/any', 200, msg
              expect_response '/other', 200, msg
              # Static get rack responses
              expect_response '/index.html', 200, msg
              expect_response '/missing', 200, msg
            end
          end
        end
      end
    end
  end
end

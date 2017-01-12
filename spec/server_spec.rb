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
          with_running_server(options) do
            expect_response '/', 200, index_body
            expect_response '/index.html', 200, index_body, 'Content-Type' => 'text/html'
            expect_response '/missing', 404
          end
        end
      end
    end
    context 'dynamic + public' do
      let(:path) { EXAMPLE1_ROOT }
      let(:handlers) { [Testing::BasicHandler, Testing::ExtraHandler] }
      context 'requests' do
        it 'handles all known types' do
          with_running_server(options) do
            # Dynamic
            expect_response '/halt_404', 404, ''
            expect_response '/halt_500', 500, 'Something went wrong'
            expect_response '/extra', 200, 'Hello from extra!'
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
    context 'dynamic + no public' do
      let(:path) { EXAMPLE3_ROOT }
      let(:handlers) { [Testing::BasicHandler, Testing::ExtraHandler] }
      context 'requests' do
        it 'handles all known types' do
          with_running_server(options) do
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
end

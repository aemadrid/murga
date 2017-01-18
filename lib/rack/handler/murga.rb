module Rack
  module Handler
    class Murga < Rack::Handler
      def self.run(app, options = {})
        server = Murga::Server.new options
        server.add_rack_handler app
        server.run
      end
    end
  end
end
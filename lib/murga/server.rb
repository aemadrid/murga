module Murga
  class Server

    java_import 'ratpack.server.RatpackServer'
    java_import 'ratpack.handling.RequestLogger'

    def self.run(options = {})
      server = new(options).start

      Signal.trap('INT') { server.stop; exit }
      Signal.trap('TERM') { server.stop; exit }

      sleep 1 while true
    end

    attr_reader :config

    def initialize(options = {})
      @config = Config.new options
    end

    def server
      @server ||= RatpackServer.of do |s|
        s.server_config server_config
        s.handlers do |chain|
          add_request_logger chain
          add_public_index chain
          add_custom_handlers chain
          add_default_handler chain
        end
      end
    end

    def start
      return false if running?

      ensure_peaceful_exit
      do_start
    end

    alias :run :start

    def stop
      return false unless running?

      server.stop
      @running = false
      true
    end

    alias :shutdown :stop

    def running?
      !!@running
    end

    private

    def server_config
      config.server_config
    end

    def do_start
      @running = true
      server.start
    rescue Exception => e
      @running = false
      raise e
    end

    def add_request_logger(chain)
      chain.all RequestLogger.ncsa if config.log_requests?
    end

    def add_custom_handlers(chain)
      config.handlers.each { |klass| chain.all klass }
    end

    def add_public_index(chain)
      return unless config.public?

      chain.files do |f|
        f.dir config.public_name
        f.index_files config.index_name
      end
    end

    def add_default_handler(chain)
      chain.all Handler::Default
    end

    def ensure_peaceful_exit
      return unless @defined_at_exit.nil?

      at_exit { stop }

      @defined_at_exit = true
    end

    def dir?(path)
      path.exist? && path.directory?
    end

  end
end

module Murga
  class Server

    java_import 'ratpack.server.RatpackServer'
    java_import 'ratpack.handling.RequestLogger'
    java_import 'org.slf4j.LoggerFactory'

    def self.run(options = {})
      new(options).run
    end

    def self.logger
      LoggerFactory.get_logger RequestLogger.ncsa.java_class
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

    def add_handler(klass)
      config.handlers.add klass
    end

    def add_rack_handler(app, handler = Murga::Handler::Rack)
      options = { app: app }
      config.handlers.add [handler, options]
    end

    def start
      return false if running?

      ensure_peaceful_exit
      do_start
    end

    def run
      start

      Signal.trap('INT') { stop; exit }
      Signal.trap('TERM') { stop; exit }

      sleep 1 while true
    end

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
      config.handlers.each do |klass_or_ary|
        if klass_or_ary.is_a? Array
          klass, options = klass_or_ary
          klass.config options if klass.respond_to?(:config)
          chain.all klass
        else
          chain.all klass_or_ary
        end
      end
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

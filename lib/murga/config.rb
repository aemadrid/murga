module Murga
  class Config

    java_import 'ratpack.server.BaseDir'
    java_import 'ratpack.server.ServerConfig'

    DEVELOPMENT = 'development'

    def initialize(options = {})
      @options = options.with_indifferent_access

      raise 'Missing base_dir' unless base_dir.present?
    end

    def host
      @host ||= options[:host] || '0.0.0.0'
    end

    def port
      @port ||= (options[:port] || '3000').to_i
    end

    def address
      @address ||= java.net.InetAddress.getByName host
    end

    def env
      @env ||= options[:env] || DEVELOPMENT
    end

    def log_requests?
      options[:log_requests].to_s == 'true'
    end

    def handlers
      @handlers ||= Set.new options[:handlers] || []
    end

    def base_dir
      @base_dir ||= base_dir_from_options || found_basedir
    end

    def base_path
      @base_path ||= Pathname.new base_dir.to_s
    end

    def public_name
      options.fetch(:public_name, 'public')
    end

    def public_path
      @public_path ||= base_path.join public_name
    end

    def public?
      public_path.directory?
    end

    def props_name
      options.fetch(:props_name, 'application.properties')
    end

    def props_path
      @props_path ||= base_path.join props_name
    end

    def index_name
      options.fetch(:index_name, 'index.html')
    end

    def props?
      props_path.file?
    end

    def metrics?
      options.fetch(:do_metrics, true)
    end

    def base_dir?
      base_dir.present?
    end

    def server_config
      cfg = ServerConfig
        .embedded
        .port(port)
        .address(address)
        .development(development?)
      cfg = cfg.base_dir(base_dir) if base_dir?
      cfg = cfg.props(props_name) if props?
      cfg
    end

    def to_s
      "#<#{self.class.name} #{vars_str}>"
    end

    alias :inspect :to_s

    private

    attr_reader :options

    def vars_str
      %i{ host port env }.map { |x| "#{x}=#{send(x).inspect}" }.join(' ')
    end

    def development?
      env == DEVELOPMENT
    end

    def base_dir_from_options
      return false unless options[:base_dir]

      java.nio.file.FileSystems.get_default.get_path options[:base_dir].to_s
    end

    def found_basedir
      BaseDir.find
    rescue Java::JavaLang::IllegalStateException
      false
    end

  end
end
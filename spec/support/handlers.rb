module Testing
  class BasicHandler < Murga::Handler::Base
    def handles
      {
        ''         => :root,
        'halt_404' => :not_found,
        'halt_500' => :sys_error,
        'params'   => :params,
      }
    end

    def handles_request?
      handles.keys.include? request.path
    end

    def process_request
      meth = handles[request.path]
      send "on_#{meth}"
    end

    def on_root
      'Hello from root!'
    end

    def on_not_found
      halt 404
    end

    def on_sys_error
      halt 500, 'Something went wrong'
    end

    def on_params
      params
    end
  end
  class ExtraHandler < Murga::Handler::Base
    def handles_request?
      request.path == 'extra'
    end

    def process_request
      render 'Hello from extra!'
    end
  end
end
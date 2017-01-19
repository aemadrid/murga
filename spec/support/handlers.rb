module Testing
  class SimpleHandler < Murga::Handler::Basic
    def handles
      {
        ''         => :root,
        'halt_404' => :not_found,
        'halt_500' => :sys_error,
        'params'   => :params,
        'error'   => :error,
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
      render status: 404
    end

    def on_sys_error
      render body: 'Something went wrong', status: 500
    end

    def on_params
      params
    end

    def on_error
      raise params[:msg] || 'missing'
    end
  end
  class ExtraHandler < Murga::Handler::Basic
    def handles_request?
      request.path == 'extra'
    end

    def process_request
      'Hello from extra!'
    end
  end
  class PostHandler < Murga::Handler::Basic
    def handles_request?
      request.path == 'posting' && request.is_post?
    end

    def process_request
      'Hello from posting!'
    end
  end
end
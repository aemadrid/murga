module RequestsHelper

  def expect_response(path, exp_status = 200, exp_body = nil, exp_headers = {}, options = {})
    resp, type = request path, options

    status  = resp.code
    body    = resp.body.to_s
    headers = resp.headers.to_hash

    puts "[#{type}:#{path}] resp : status  : #{status}"
    puts "[#{type}:#{path}] resp : body    : #{body}"
    puts "[#{type}:#{path}] resp : headers : #{headers}"

    if exp_status
      expect(status).to eq(exp_status),
                        "expected #{type.to_s.upcase} request to [#{path}]\n" +
                          "  to give a status [#{exp_status}]\n" +
                          "  instead of [#{status}]"
    end

    if exp_body
      expect(body).to eq(exp_body.to_s),
                      "expected #{type.to_s.upcase} request to [#{path}]\n" +
                        "  to give a body [(#{exp_body.size})#{exp_body}]\n" +
                        "  instead of [(#{body.size})#{body}]"
    end

    if exp_headers
      exp_headers.each do |k, v|
        expect(headers[k]).to eq(v),
                              "expected #{type.to_s.upcase} request to [#{path}]\n" +
                                "  to give a header of [#{k}:#{v}]\n" +
                                "  instead of [#{k}:#{headers[k] || '<<missing>>'}]"
      end
    end
  end

  def expect_json_response(path, exp_hsh = {}, options = {})
    resp, type = request path, options

    status  = resp.code
    body    = resp.body.to_s
    headers = resp.headers.to_hash

    hsh = JrJackson::Json.load body

    puts "[#{type}:#{path}] resp : status  : #{status}"
    puts "[#{type}:#{path}] resp : body    : #{body}"
    puts "[#{type}:#{path}] resp : headers : #{headers}"

    exp_status = options[:status] || 200
    expect(status).to eq(exp_status),
                      "expected #{type.to_s.upcase} JSON request to [#{path}]\n" +
                        "  to give a status [#{exp_status}]\n" +
                        "  instead of [#{status}]"

    expect(hsh).to eq(exp_hsh),
                   "expected #{type.to_s.upcase} JSON request to [#{path}]\n" +
                     "  to give a parsed (#{exp_hsh.size}) #{exp_hsh.inspect}\n" +
                     "        instead of (#{hsh.size}) #{hsh.inspect}"

    exp_headers = { 'Content-Type' => Murga::Handler::Base::JSON_CONTENT_TYPE }
    exp_headers.each do |k, v|
      expect(headers[k]).to eq(v),
                            "expected #{type.to_s.upcase} JSON request to [#{path}]\n" +
                              "  to give a header of [#{k}:#{v}]\n" +
                              "  instead of [#{k}:#{headers[k] || '<<missing>>'}]"
    end
  end

  def server_url(path = nil)
    "http://#{host}:#{port}#{path}"
  end

  def request(path, options = {})
    type = options.delete(:method) || :get

    puts "[#{type}:#{path}] requesting ..."
    url = server_url path

    headers = options.delete(:headers) || {}
    resp    = HTTP.
      headers(headers).
      timeout(write: 2, connect: 2, read: 3).
      send(type, url, options)
    [resp, type]
  end

  def file(*paths)
    File.read path.join(*paths)
  end

  def with_running_server(options = {})
    server = described_class.new options
    server.start
    yield
    server.stop
  end

end

RSpec.configure do |config|
  config.include RequestsHelper
end

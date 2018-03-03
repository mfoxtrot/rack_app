require_relative 'time_response'
class App

  def call(env)
    params = Rack::Request.new(env).env
    if params['PATH_INFO'] == '/time'
      response(200, TimeResponse.new(Rack::Utils.parse_nested_query(params['QUERY_STRING'])).call)
    else
      response(404, "Unknown resource '#{params['PATH_INFO']}'")
    end
  end

  private

  def response(response_code, response_text)
    [
      response_code,
      {'Content-Type' => 'text/plain'},
      [response_text]
    ]
  end

end

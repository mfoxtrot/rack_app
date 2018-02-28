require_relative 'time_response'
class App

  def call(env)
    params = Rack::Request.new(env).env
    if params['PATH_INFO'] == '/time'
      TimeResponse.new(Rack::Utils.parse_nested_query(params['QUERY_STRING'])).call
    else
      unknown_resource(params['PATH_INFO'])
    end
  end

  private

  def unknown_resource(resource)
    [
      404,
      {'Content-Type' => 'text/plain'},
      ["Unknown resource '#{resource}'"]
    ]
  end

end

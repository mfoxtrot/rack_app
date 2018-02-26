class App

  TIME_FORMATS = {year: "%Y", month: "-%m", day: "-%d", hour: " %H", minute: ":%M", second: ":%S"}
  CONTENT_TYPE = {'Content-Type' => 'text/plain'}

  def call(env)
    if  env['REQUEST_METHOD'] == 'GET'
      if env['PATH_INFO'] == '/time'
        params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
        return_answer(params)
      else
        unknown_resource(env['PATH_INFO'])
      end
    else
      not_get_query
    end
  end

  private

  def return_answer(params)
    formats = []
    unknown_formats = []

    params["format"].split(',').each do |f|
      if TIME_FORMATS.keys.include?(f.to_sym)
        formats << TIME_FORMATS[f.to_sym]
      else
        unknown_formats << f
      end
    end

    unknown_formats.size > 0 ? unknown_formats_response(unknown_formats) : time_response(formats)
  end

  def unknown_resource(resource)
    [
      404,
      CONTENT_TYPE,
      ["Unknown resource '#{resource}'"]
    ]
  end

  def not_get_query
    [
      200,
      CONTENT_TYPE,
      ["Not a GET query"]
    ]
  end

  def unknown_formats_response(formats)
    [
      200,
      CONTENT_TYPE,
      ["Unknown time format #{formats}"]
    ]
  end

  def time_response(formats)
    formatted_time = DateTime.now.strftime(formats.join(''))
    [
      200,
      CONTENT_TYPE,
      ["#{formatted_time}"]
    ]
  end
end

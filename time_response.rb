class TimeResponse
  TIME_FORMATS = {year: "%Y", month: "-%m", day: "-%d", hour: " %H", minute: ":%M", second: ":%S"}

  def initialize(params)
    @params = params
    @formats = []
    @unknown_formats = []
  end

  def call
    check_formats
    response
  end

  private

  def check_formats
    @params["format"].split(',').each do |f|
      if TIME_FORMATS.keys.include?(f.to_sym)
        @formats << TIME_FORMATS[f.to_sym]
      else
        @unknown_formats << f
      end
    end
  end

  def response
    [
      200,
      {'Content-Type' => 'text/plain'},
      [response_text]
    ]
  end

  def response_text
    return "Unknown time format #{@unknown_formats}" if @unknown_formats.size > 0
    DateTime.now.strftime(@formats.join(''))
  end

end

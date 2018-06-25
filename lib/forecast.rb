require 'uri'

require 'net/http'

require 'rexml/document'

require 'date'


class Forecast
  WEATHER = ['Ясно,' 'Малооблачно', 'Облачно', 'Пасмурно'].freeze

  def self.read_from_xml(path)
    @two_days_forecast = []

    if path =~ /https/

    uri = URI.parse(path)

    response = Net::HTTP.get_response(uri)
    doc = REXML::Document.new(response.body)

    else
      doc = REXML::Document.new(File.read(path))
    end



    city_name = URI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])

    doc.root.elements['REPORT/TOWN'].each_element do |forc|
      min_temp = forc.elements['TEMPERATURE'].attributes['min']
      max_temp = forc.elements['TEMPERATURE'].attributes['max']
      max_wind = forc.elements['WIND'].attributes['max']
      clouds_index = forc.elements['PHENOMENA'].attributes['cloudiness'].to_i
      clouds = WEATHER[clouds_index]
      date = parse_date_from_xml(forc)

      @two_days_forecast << Forecast.new(city_name, date, min_temp, max_temp, max_wind, clouds)
    end
  end

  def self.two_days_forecast
    puts @two_days_forecast.first.city
    puts
    @two_days_forecast.each do |forecast|
      forecast.print_forecast_to_console
    end
  end

  def self.parse_date_from_xml(forecast)
    day = forecast.attributes['day']
    month = forecast.attributes['month']
    year = forecast.attributes['year']
    hour = forecast.attributes['hour']

    date = Date.parse("#{day}-#{month}-#{year}").strftime("%d.%m")
    if date == Time.now.strftime("%d.%m")
      if hour == '09'
        date = "Сегодня утром"
      elsif hour == '15'
        date = "Сегодня днем"
      elsif hour == '21'
        date = "Сегодня вечером"
      end
    end

    date

  end

  def initialize(city_name, date, min_temp, max_temp, max_wind, clouds)
    @date = date
    @city = city_name
    @min_temp = min_temp
    @max_temp = max_temp
    @max_wind = max_wind
    @clouds = clouds
  end

  def print_forecast_to_console
    puts @date
    puts "Температура воздуха - #{@min_temp} #{@max_temp} C"
    puts "Ветер #{@max_wind} м/с"
    puts @clouds
    puts
  end

  def city
    @city
  end
end
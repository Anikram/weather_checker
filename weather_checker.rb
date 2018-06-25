require_relative 'lib/forecast'

#Forecast.read_from_xml('data/134.xml')
Forecast.read_from_xml('https://xml.meteoservice.ru/export/gismeteo/point/134.xml')

Forecast.two_days_forecast
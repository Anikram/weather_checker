#Anikram 2018 - ver. 2
require_relative 'lib/forecast'

CITIES = {москва: 'https://xml.meteoservice.ru/export/gismeteo/point/37.xml',
таганрог: 'https://xml.meteoservice.ru/export/gismeteo/point/134.xml',
самара: 'https://xml.meteoservice.ru/export/gismeteo/point/125.xml'}

CITIES_POINTERS = %w(0 москва таганрог самара)

def list_cities
  i = 1
  CITIES.each_key do |city|
    puts "#{i}. #{city}"
    i += 1
  end
end

def get_user_input
  input = nil

  until input.is_a?(Integer)
    input = STDIN.gets.to_i
  end

  if input > (CITIES_POINTERS.length - 1) || input < 0
    abort('Города с таким номером - нет')
  else
    CITIES[CITIES_POINTERS[input].to_sym]
  end
end

def parse_user_input(input)
  city_list = CITIES.to_a

  the_city = :none

  city_list.each do |array|
    array.each do |item|
      if item == input
        the_city = (array - item).to_sym
      end
    end
  end

  the_city
end


puts 'Вас приветсвует приложение \'Узнай погоду\''
puts
puts 'Пожалуйста выберите город, чтобы узнать погоду на сегодня-завтра:'
puts "Список городов:"

list_cities

#Forecast.read_from_xml('data/134.xml')
Forecast.read_from_xml(get_user_input)

Forecast.two_days_forecast
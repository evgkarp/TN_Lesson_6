require_relative 'valid'
require_relative 'maker'
require_relative 'instance_counter'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class Main
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []  
  end

  def start
    loop do
      puts "Выберите действие:
        1 - Создать станцию
        2 - Создать поезд
        3 - Создать маршрут
        4 - Добавить станцию в маршрут
        5 - Удалить станцию из маршрута
        6 - Назначить маршрут поезду
        7 - Добавить вагон к поезду
        8 - Отцепить вагон от поезда
        9 - Переместить поезд вперед по маршруту
        10 - Переместить поезд назад по маршруту
        11 - Посмотреть список станций
        12 - Посмотреть список поездов на станции
        0 - Выход"

      action = gets.to_i

      break if action == 0 

      case action
        when 1
          create_station

        when 2
          create_train

        when 3
          create_route

        when 4
          add_station

        when 5
          delete_station

        when 6
          set_route

        when 7
          add_wagon       

        when 8
          delete_wagon

        when 9
          train_go_forward

        when 10
          train_go_backward
          
        when 11
          trains_list
                    
        when 12
          stations_list
          
        else
          puts "Введите число от 0 до 12"
      end
    end  
  end

private 

  def create_station
    puts "Введите название станции: "
    name = gets.chomp
    station = Station.new(name)
    @stations << station
    puts "Создана станция #{station.name}"
  rescue => e
    puts e.message
    retry
  end

  def choose_station
    puts "Введите название станции"
    name = gets.chomp
    station_name = @stations.find { |station| station.name == name }
    if station_name.nil?
      raise "Такой станции не существует"
    else  
      station_name
    end
  end

  def create_train
    type = input_type_of_train
    if type == 1
      create_passenger_train
    elsif type == 2
      create_cargo_train
    end
  end

  def create_passenger_train
    number = input_number_of_train
    train = PassengerTrain.new(number)
    @trains << train
    puts "Создан пассажирский поезд номер #{number}"
  rescue => e
    puts e.message
    retry
  end

  def create_cargo_train
    number = input_number_of_train
    train = CargoTrain.new(number)
    @trains << train
    puts "Создан грузовой поезд номер #{number}"
  rescue => e
    puts e.message
    retry
  end

  def input_number_of_train
    puts "Введите номер поезда: "
    number = gets.to_s
  end

  def choose_train
    number = input_number_of_train
    train_number = @trains.find { |train| train.number == number } 
    if train_number.nil?
      raise "Такого поезда не существует" 
    else
      train_number
    end
  end

  def input_type_of_train
    puts "Введите тип поезда: 
    1 - Пассажирский
    2 - Грузовой"
    type = gets.to_i
    if (type != 1) && (type != 2)
      puts "Введите 1 или 2" 
    else
      type
    end
  end

  def create_route
    stations_empty
    two_stations_minimum
    puts "Начальная станция: "
    start = choose_station
    puts "Конечная станция: "
    finish = choose_station
    route = Route.new(start, finish)
    @routes << route
    puts "Создан маршрут #{start.name} - #{finish.name}"
  rescue => e
    puts e.message
  end

  def choose_route
    puts "Введите порядковый номер маршрута: "
    number = gets.to_i
    route = @routes[number - 1]
    if route.nil?
      raise "Введите номер от 1 до #{@routes.size}" 
    else
      route
    end
  end

  def route_empty
    raise "Нет ни одного маршрута" if @routes.empty?
  end

  def add_station
    route_empty
    station = choose_station
    route = choose_route
    route.add_station(station)
    puts "Станция #{station.name} добавлена в маршрут"
  rescue => e
    puts e.message
  end

  def delete_station
    route_empty
    station = choose_station
    route = choose_route
    route.delete_station(station)
    puts "Станция #{station.name} удалена из маршрута"
  rescue => e 
    puts e.message
  end

  def set_route
    route_empty
    trains_empty
    train = choose_train
    route = choose_route
    train.route = route
    puts "Маршрут назначен поезду номер #{train.number}" 
  rescue => e 
    puts e.message   
  end

  def add_wagon
    trains_empty
    train = choose_train
    if train.class == PassengerTrain
      wagon = create_passenger_wagon
    else
      wagon = create_cargo_wagon                   
    end
    train.add_wagon(wagon) 
    puts "К поезду номер #{train.number} прицеплен вагон"
  rescue => e
    puts e.message
  end

  def delete_wagon
    trains_empty
    train = choose_train
    train.delete_wagon
    puts "От поезда номер #{train.number} отцеплен вагон"
  rescue => e
    puts e.message
  end

  def create_passenger_wagon
    wagon = PassengerWagon.new
  end

  def create_cargo_wagon
    wagon = CargoWagon.new
  end 

  def train_go_forward
    trains_empty
    train = choose_train
    has_route(train)
    train.go_forward
    puts "Поезд номер #{train.number} перемещен на станцию #{train.current_station.name}" 
    #Почему при выводе сообщения после #{train.number} происходит перенос строки?
  rescue => e
    puts e.message 
  end

  def train_go_backward
    trains_empty
    train = choose_train
    has_route(train)
    train.go_backward
    puts "Поезд номер #{train.number} перемещен на станцию #{train.current_station.name}"
  rescue => e
    puts e.message 
  end

  def trains_list
    stations_empty
    @stations.each { |station| puts station.name }
  rescue => e
    puts e.message
  end

  def stations_list
    stations_empty
    station = choose_station
    if station.trains.empty?
      puts "На станции #{station.name} нет поездов"
    else
      station.trains.each { |train| puts train.number }
    end    
  rescue => e
    puts e.message
  end

  def has_route(train)
    raise "Необходимо назначить маршрут поезду" if train.route.nil?
  end

  def trains_empty
    raise "Нет ни одного поезда" if @trains.empty?    
  end

  def stations_empty
    raise "Нет ни одной станции" if @stations.empty?    
  end

  def two_stations_minimum
    raise "Необходимо создать минимум 2 станции" if @stations.size < 2   
  end
end

x = Main.new
x.start
class Train
  include Maker
  include InstanceCounter
  include Valid
  NUMBER_FORMAT = /^[а-я\d]{3}-?[а-я\d]{2}$/i

  attr_reader :number, :speed, :type, :wagons, :route

  @@trains = {}

  def self.find(number)
    @@trains[number]    
  end

  def initialize(number)
    @number = number    
    validate!
    @speed = 0
    @station_index = 0
    @wagons = []
    @@trains[number] = self
    register_instance
  end

  def speed_up
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def route=(route)
    @route = route
    @station_index = 0
    current_station.take_train(self)
  end

  def go_forward
    last_station?
    current_station.send_train(self)
    @station_index += 1
    current_station.take_train(self)  
  end

  def go_backward
    first_station?    
    current_station.send_train(self)
    @station_index -= 1
    current_station.take_train(self)  
  end

  def current_station
    @route.stations[@station_index]    
  end

  def next_station
    last_station?
    @route.stations[@station_index + 1]   
  end 
  
  def previous_station
    first_station?
    @route.stations[@station_index - 1]     
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed.zero? && self.type == wagon.type
  end

  def delete_wagon
    raise "Нельзя отцепить вагон пока поезд движется" if @speed > 0
    raise "В поезде больше нет вагонов" if @wagons.empty?
    @wagons.pop
  end

protected

  def validate!
    raise "Номер не может быть пустым" if number.nil?
    raise "Номер должен состоять минимум из 5 символов" if number.length < 5
    raise "Неверный формат номера" if number !~ NUMBER_FORMAT
  end

  def first_station?
    raise "Поезд находится на первой станции" if @route.stations[@station_index] == @route.stations[0]
  end

  def last_station?
    raise "Поезд находится на конечной станции" if @route.stations[@station_index] == @route.stations[-1]
  end
end
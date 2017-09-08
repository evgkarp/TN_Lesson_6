class Route
  include InstanceCounter
  include Valid
  
  attr_reader :stations, :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)    
  end

  def delete_station(station)
    start?(station)
    finish?(station)
    @stations.delete(station)  
  end

  protected

  def start?(station)
    raise "Нельзя удалить первую станцию маршрута" if station == @start
  end

  def finish?(station)
    raise "Нельзя удалить конечную станцию маршрута" if station == @finish
  end
end
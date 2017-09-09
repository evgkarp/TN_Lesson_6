class Route
  include InstanceCounter
  
  attr_reader :stations

  def initialize(start, finish)
    @stations = [start, finish]   
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)    
  end

  def delete_station(station)
    raise "Нельзя удалить первую станцию маршрута" if station == @stations[0]
    raise "Нельзя удалить конечную станцию маршрута" if station == @stations[-1]
    @stations.delete(station)  
  end
end
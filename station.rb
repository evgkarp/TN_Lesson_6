class Station
  include InstanceCounter
  include Valid

  attr_reader :name, :trains
  
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
    validate!
  end

  def take_train(train)
    @trains << train
  end

  def trains_by_type(type)
     @trains.select { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train)    
  end

  protected

  def validate!
    raise "Название не может быть пустым" if name.nil?
    raise "Название должно состоять минимум из 2 символов" if name.length < 2
    true
  end
end
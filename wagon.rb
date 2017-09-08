class Wagon
  include Maker
  include InstanceCounter

  attr_reader :type

  def initialize
    register_instance
  end
end

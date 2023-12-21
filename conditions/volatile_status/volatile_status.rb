require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
require_relative "../../types/type_factory"

class VolatileConditions
  attr_accessor :name, :turn, :duration, :data

  def initialize(name:, turn: 0, duration: nil, data: nil)
    @name = name
    @turn = turn
    @duration = duration
    @data = data
  end

  def turn_count
    @turn += 1
  end

  def wear_off?
    turn == duration
  end

  def ==(other)
    name == other.name
  end

  def dmg_effect(pok)
    nil
  end
end
require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
require_relative "../../types/type_factory"

class VolatileConditions
  attr_accessor :name, :turn, :duration

  def initialize(name:, turn: 0, duration: nil)
    @name = name
    @turn = turn
    @duration = duration
  end

  def turn_count
    @turn += 1
  end

  def wear_off?
    turn == duration
  end
end
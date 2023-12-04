require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
require_relative "../../types/type_factory"

class HealthConditions
  attr_accessor :name, :immune_type, :turn

  def initialize(name:, immune_type: nil)
    @name = name
    @immune_type = immune_type
  end

  def dmg_effect(pokemon); end

  def unable_to_move
    false
  end

  def stat_nerf; end

  def init_count
    @turn = 0
  end

  def turn_count
    @turn += 1
  end

  def ==(other)
    name == other
  end
end
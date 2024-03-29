require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
require_relative "../../types/type_factory"
require_relative "../../messages_pool"
require_relative "../../battle_log"

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
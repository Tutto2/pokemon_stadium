require_relative "moves"
require_relative "concerns/move_modifiers"

class ElectroBallMove < Move
  include BasicSpecialAtk
  include HasCustomTable

  def self.learn
    new(  attack_name: :electro_ball,
          type: Types::ELECTRIC,
          category: :special,
        )
  end

  private
  def table
    [
      [0...1, 40],
      [1...2, 60],
      [2...3, 80],
      [3...4, 120],
      [4.., 150]
    ]
  end
  
  def calculation_stat
    (pokemon.spd_value / pokemon_target.spd_value).to_f
  end
end
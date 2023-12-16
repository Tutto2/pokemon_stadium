require_relative "move"

class ElectroBallMove < Move
  include BasicSpecialAtk
  include HasCustomTable

  def self.learn
    new(
      attack_name: :electro_ball,
      type: Types::ELECTRIC,
      pp: 10,
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
    (pokemon.actual_speed / pokemon_target.actual_speed).to_f
  end
end
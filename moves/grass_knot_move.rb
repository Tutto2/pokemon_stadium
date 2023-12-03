require_relative "move"

class GrassKnotMove < Move
  include BasicSpecialAtk
  include HasCustomTable

  def self.learn
    new(  attack_name: :grass_knot,
          type: Types::GRASS,
          category: :special,
        )
  end

  private
  def table
    [
      [0...10, 20],
      [10...25, 40],
      [25...50, 60],
      [50...100, 80],
      [100...200, 100],
      [200.., 120]
    ]
  end
  
  def calculation_stat
    pokemon_target.weight.to_f
  end
end
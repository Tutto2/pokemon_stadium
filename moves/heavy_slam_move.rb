require_relative "move"

class HeavySlamMove < Move
  include BasicPhysicalAtk
  include HasCustomTable

  def self.learn
    new(  attack_name: :heavy_slam,
          type: Types::STEEL,
          category: :physical,
        )
  end

  private
  def table
    [
      [0...2, 40],
      [2...3, 60],
      [3...4, 80],
      [4...5, 100],
      [5.., 120]
    ]
  end
  
  def calculation_stat
    (pokemon.weight / pokemon_target.weight ).to_f
  end
end
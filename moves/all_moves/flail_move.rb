require_relative "../move"

class FlailMove < Move
  include BasicPhysicalAtk
  include HasCustomTable

  def self.learn
    new(
      attack_name: 'Flail',
      type: Types::NORMAL,
      pp: 15,
      category: :physical
      )
  end

  private
  
  def table
    [
      [0.6875..1, 20],
      [0.3542...0.6875, 40],
      [0.2083...0.3542, 80],
      [0.1042...0.2083, 100],
      [0.0417...0.1042, 150],
      [0...0.0417, 200]
    ]
  end

  def calculation_stat
    pokemon.hp_value.to_f / pokemon.hp_total.to_f
  end
end
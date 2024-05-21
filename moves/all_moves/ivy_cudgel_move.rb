require_relative "../move"

class IvyCudgelMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio
  include TypeChange

  def self.learn
    new(
      attack_name: 'Ivy Cudgel',
      pp: 10,
      category: :physical,
      type: Types::GRASS,
      power: 100
      )
  end

  def type
    return Types::GRASS unless pokemon.name.match?(/ogerpon/i)

    pokemon.types.last
  end
end

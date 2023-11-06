require_relative "move"


class IvyCudgelMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio
  include TypeChange

  def self.learn
    new(  attack_name: :evy_cudgel,
          category: :physical,
          type: Types::GRASS,
          power: 100
        )
  end

  private

  def type
    if pokemon.name == "Ogerpon"
      if pokemon.types.include?(Types::WATER)
        type = Types::WATER
      elsif pokemon.types.include?(Types::FIRE)
        type = Types::FIRE
      elsif pokemon.types.include?(Types::ROCK)
        type = Types::ROCK
      end
    else
      type = Types::GRASS
    end
  end
end
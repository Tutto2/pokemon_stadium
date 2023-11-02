require_relative "moves"
require_relative "concerns/move_modifiers"

class IvyCudgelMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio
  include TypeChange

  def self.learn
    new(  attack_name: :evy_cudgel,
          type: Types::GRASS,
          category: :physical,
          power: 100
        )
  end

  self.type_change    

  private

  def new_type
    if pokemon.name == "Ogerpon"
      if pokemon.types.include?(Types::WATER)
        return Types::WATER
      elsif pokemon.types.include?(Types::FIRE)
        return Types::FIRE
      elsif pokemon.types.include?(Types::ROCK)
        return Types::ROCK
      end
    else
      return Types::GRASS
    end
  end
end
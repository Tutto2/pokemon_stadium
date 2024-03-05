require_relative "move"

class SappySeedMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :sappy_seed,
      type: Types::GRASS,
      pp: 15,
      category: :physical,
      power: 90
      )
  end
  
  def secondary_effect
    volatile_status_apply(pokemon_target, SeededStatus.get_seeded(pokemon))
  end
end
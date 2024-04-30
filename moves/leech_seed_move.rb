require_relative "move"

class LeechSeedMove < Move
  def self.learn
    new(
      attack_name: 'Leech Seed',
      type: Types::GRASS,
      pp: 10,
      category: :status,
      precision: 90
      )
  end
  
  def status_effect(pokemon_target)
    volatile_status_apply(pokemon_target, SeededStatus.get_seeded(pokemon))
  end
end

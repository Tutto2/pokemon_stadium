require_relative "move"

class PhantomForceMove < Move
  include BasicPhysicalAtk
  include HasSeveralTurns

  def self.learn
    new(
      attack_name: :phantom_force,
      type: Types::GHOST,
      pp: 10,
      category: :special,
      power: 90
      )
  end

  def first_turn_action
    puts "#{pokemon.name} vanished"
    pokemon.make_invulnerable(self.attack_name)
  end

  def second_turn_action
    if pokemon_target.is_protected?
      puts "#{pokemon.name} broke through #{pokemon_target}'s protection"
      pokemon_target.protection_delete 
    end
    execute
    pokemon.vulnerable_again
    end_turn_action
  end
end
require_relative "../move"

module Messages
  def effectiveness_message(pokemon, pokemon_target, effect, move)
    effectiveness = effect

    unless move.category == :status
      if effectiveness < 1 && effectiveness > 0
        puts "It's ineffective"
      elsif effectiveness == 0
        puts "#{pokemon_target.name} it's immune"
      elsif effectiveness > 1
        puts "It's super effective"
      else
        puts "It's effective"
      end
    end
  end

  def multihit_message(strikes_count, pokemon_target)
    puts "#{pokemon_target.name} received #{strikes_count} hits"
  end

  def failed_attack_message
    puts "#{pokemon.name} used #{attack_name} (#{category}, type: #{type})"
    puts "The attack has failed"
    return false
  end

  def end_of_action_message(pokemon, pokemon_target)
    if pokemon.fainted?
      puts "#{pokemon.name} has fainted"
      puts
    end
    
    if pokemon_target.fainted?
      puts "#{pokemon_target.name} has fainted"
      puts
    elsif category != :status
      puts "#{pokemon_target.name} now has #{pokemon_target.hp_value} hp"
      puts
    end
  end
end
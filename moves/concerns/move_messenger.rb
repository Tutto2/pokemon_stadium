require_relative "../move"

module Messages
  def effectiveness_message
    effectiveness = effect

    unless self.category == :status
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

  def multihit_message(strikes_count)
    puts "#{pokemon_target.name} received #{strikes_count} hits"
  end

  def failed_attack_message
    puts "#{pokemon.name} used #{attack_name} (#{category}, type: #{type}) (since failed)"
    puts "The attack has failed"
    return false
  end

  def end_of_action_message
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

  def volatile_status_apply_msg(status)
    case status
    when :confused then puts "#{target.name} got confused!"
    when :cursed then puts "#{pokemon.name} cut his own HP and laid a curse on #{pokemon_target.name}"
    when :infatuated then puts "#{target.name} fell in love!"
    when :seeded then puts "#{target.name} was seeded"
    when :substitute then puts "#{pokemon.name} put in a substitute!"
    when :bound then puts "#{target.name} was trapped!"
    end
  end
end
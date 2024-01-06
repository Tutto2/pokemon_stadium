require_relative "../move"

module MakesTargetSwitch
  def status_effect
    target_switch
  end

  def target_switch
    target_team = pokemon_target.trainer.team.reject { |pok| pok == pokemon_target }
    return puts "#{pokemon_target.trainer.name} has no pokemon remaining, #{attack_name} failed." if target_team.all?(&:fainted?)
    
    pokemon_target.stats.each do |stat|
      stat.reset_stat
    end
    pokemon_target.reinit_all_metadata
    pokemon_target.reinit_volatile_condition

    pokemon_target.trainer.current_pokemon = target_team.sample
    puts
    puts "#{pokemon_target.trainer.current_pokemon} got out to battle!"
  end
end
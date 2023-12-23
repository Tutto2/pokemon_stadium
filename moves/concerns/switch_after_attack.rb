require_relative "../move"

module SwitchAfterAttack
  def cant_switch?
    team = pokemon.trainer.team.reject { |pok| pok == pokemon }
    
    team.all?(&:fainted?)
  end

  def status_effect
    switch_effect
  end

  def secondary_effect
    switch_effect
  end

  def switch_effect
    return puts "#{pokemon.trainer.name} has no pokemon remaining, #{pokemon.name} couldn't switch" if cant_switch?
    puts
    Menu.pokemon_selection_index(pokemon.trainer, pokemon, source: :move).perform
  end
end
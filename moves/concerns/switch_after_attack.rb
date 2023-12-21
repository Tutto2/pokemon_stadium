require_relative "../move"

module SwitchAfterAttack
  def precision
    team = pokemon.trainer.team.reject { |pok| pok == self }
    
    team.all?(&:fainted?) ? 0 : 100
  end

  def secondary_effect
    puts
    Menu.pokemon_selection_index(pokemon.trainer, pokemon, source: :move).perform
  end
end
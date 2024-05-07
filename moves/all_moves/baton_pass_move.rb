require_relative "../move"

class BatonPassMove < Move
  include SwitchAfterAttack

  def self.learn
    new(
      attack_name: 'Baton Pass',
      type: Types::NORMAL,
      pp: 40,
      category: :status
      )
  end

  def switch_effect
    Menu.pokemon_selection_index(pokemon.trainer, pokemon, source: :baton_pass).perform
  end
end

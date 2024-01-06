require_relative "move"

class FutureSightMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :future_sight,
      type: Types::PSYCHIC,
      pp: 10,
      category: :special,
      power: 120
      )
  end

  def action_for_other_turn?
    true unless pokemon.fainted?
  end

  def additional_action(pokemon)
    puts "#{pokemon.name} has foreseen an attack."
  end

  def handle_in_other_turn
    pokemon.trainer.keep_action(wrap_in_action, 2)
  end

  def wrap_in_action
    AttackAction.new(
      speed: pokemon.actual_speed,
      behaviour: self,
      trainer: pokemon.trainer,
      user_pokemon: pokemon,
      target: pokemon_target.trainer
    )
  end
end
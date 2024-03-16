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
    BattleLog.instance.log(MessagesPool.future_sight_msg(pokemon.name))
  end

  def handle_in_other_turn(pokemon_target)
    pokemon.trainer.keep_action(wrapped_action(pokemon_target), 2)
  end

  def wrapped_action(pokemon_target)
      AttackAction.new(
      speed: pokemon.actual_speed,
      behaviour: self,
      trainer: pokemon.trainer,
      user_pokemon: pokemon,
      target: pokemon_target_index(pokemon_target)
      )
  end

  def pokemon_target_index(pokemon_target)
    index = pokemon_target.field_position
    index > 2 ? [2] : [1]
  end
end
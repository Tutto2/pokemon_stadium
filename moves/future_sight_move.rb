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

  def handle_in_other_turn
    pokemon.trainer.keep_action(wrapped_action, 2)
  end

  def wrapped_action
      AttackAction.new(
      speed: pokemon.actual_speed,
      behaviour: self,
      trainer: pokemon.trainer,
      user_pokemon: pokemon,
      target: pokemon_target_index
      )
  end

  def pokemon_target_index
    return 0 if pokemon.trainer.opponents.size == 1 && pokemon.trainer.opponents.current_pokemons.size == 1
    
    pokemon.trainer.opponents[0].current_pokemons[0] == pokemon_target ? 1 : 2
  end
end
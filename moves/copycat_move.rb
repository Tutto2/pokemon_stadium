require_relative "move"

class CopycatMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: :copycat,
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    atk_list = pokemon.trainer.battleground.attack_list
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if atk_list.size < 2 
    last_attack = atk_list.values.last
    last_attack.perform_attack(pokemon, [pokemon_target])
  end
end
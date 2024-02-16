require_relative "move"

class CopycatMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: :copycat,
      type: Types::NORMAL,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if pokemon.trainer.battlefield.attack_list.size < 2 
    last_attack = pokemon.trainer.battlefield.attack_list.values.last
    last_attack.perform_attack(pokemon, pokemon_target)
  end
end
require_relative "move"

class CopycatMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: :copycat,
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if pokemon.trainer.battlefield.attack_list.size < 2 
    pokemon.trainer.battlefield.attack_list[-2].perform_attack(pokemon, pokemon_target)
  end
end
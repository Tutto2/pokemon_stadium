require_relative "move"

class SpiteMove < Move
  def self.learn
    new(
      attack_name: :spite,
      type: Types::GHOST,
      pp: 10,
      category: :status
      )
  end

  private
  def status_effect
    previous_atk = pokemon.trainer.battlefield.attack_list["#{pokemon_target.name}"].behaviour
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if previous_atk.nil? || previous_atk.pp <= 0

    BattleLog.instance.log(MessagesPool.spite_msg(pokemon_target.name, previous_atk.attack_name))
    (previous_atk.pp -= 4).clamp(0, 40)
  end
end
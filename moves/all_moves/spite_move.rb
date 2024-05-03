require_relative "move"

class SpiteMove < Move
  def self.learn
    new(
      attack_name: 'Spite',
      type: Types::GHOST,
      pp: 10,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    previous_atk = pokemon.trainer.battleground.attack_list["#{pokemon_target.name}"]
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if previous_atk.nil?

    BattleLog.instance.log(MessagesPool.spite_msg(pokemon_target.name, previous_atk.attack_name))
    (previous_atk.pp -= 4).clamp(0, 40)
  end
end

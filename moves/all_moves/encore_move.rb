require_relative "../move"

class EncoreMove < Move
  def self.learn
    new(
      attack_name: 'Encore',
      type: Types::NORMAL,
      pp: 5,
      category: :status,
      precision: nil,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    previous_attack = pokemon_target.trainer.battleground.attack_list["#{pokemon_target.name}"]
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if previous_attack.nil?
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if previous_attack.cant_be_use_by_encore?
    
    volatile_status_apply(pokemon_target, EncoredStatus.get_encored)
  end
end
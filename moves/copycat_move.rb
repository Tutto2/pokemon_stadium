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
    last_attack = pokemon.trainer.battleground.attack_list["last_attack"]

    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if last_attack.nil?

    last_attack.assing_target if last_attack.target.nil?
    last_attack.perform_attack(pokemon, [pokemon_target]) if last_attack.target == 'one_opp'

    targets = pokemon.assing_target(last_attack, nil)
    last_attack.perform_attack(pokemon, targets)
  end
end
require_relative "move"

class FocusEnergyMove < Move
  def self.learn
    new(
      attack_name: 'Focus Energy',
      type: Types::NORMAL,
      pp: 30,
      category: :status
      )
  end

  def status_effect(pokemon_target)
    BattleLog.instance.log(MessagesPool.focus_energy_msg(pokemon.name))
    pokemon.increase_crit_stage(2)
  end
end

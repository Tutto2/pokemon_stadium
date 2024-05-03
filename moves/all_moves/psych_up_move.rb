require_relative "move"

class PsychUpMove < Move
  include MigratePokInfo

  def self.learn
    new(
      attack_name: 'Psych Up',
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      target: 'one_opp'
      )
  end

  def status_effect(pokemon_target)
    BattleLog.instance.log(MessagesPool.psych_up_msg(pokemon.name, pokemon_target.name))
    migrate_stat_stages(pokemon_target)
  end
end

require_relative "move"

class PsychUpMove < Move
  include MigratePokInfo

  def self.learn
    new(
      attack_name: :psych_up,
      type: Types::NORMAL,
      pp: 10,
      category: :status
      )
  end

  def status_effect
    BattleLog.instance.log(MessagesPool.psych_up_msg(pokemon.name, pokemon_target.name))
    migrate_stat_stages
  end
end
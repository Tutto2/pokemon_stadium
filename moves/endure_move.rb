require_relative "move"

class EndureMove < Move
  def self.learn
    new(
      attack_name: :endure,
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      priority: 4
      )
  end

  private
  def status_effect
    BattleLog.instance.log(MessagesPool.endure_msg(pokemon.name))
    pokemon.will_survive
  end
end
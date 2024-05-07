require_relative "../move"

class EndureMove < Move
  def self.learn
    new(
      attack_name: 'Endure',
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      priority: 4
      )
  end

  private
  def status_effect(pokemon_target)
    BattleLog.instance.log(MessagesPool.endure_msg(pokemon.name))
    pokemon.will_survive
  end
end

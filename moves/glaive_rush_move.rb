require_relative "move"

class GlaiveRushMove < Move
  include BasicPhysicalAtk
  include PostEffect

  def self.learn
    new(
      attack_name: 'Glaive Rush',
      type: Types::DRAGON,
      pp: 5,
      category: :physical,
      power: 120
      )
  end

  private
  def post_effect(pokemon)
    pokemon.metadata[:post_effect] = "vulnerable"
    BattleLog.instance.log(MessagesPool.vulnerable_msg(pokemon.name))
  end
end

require_relative "../move"

class BurnUpMove < Move
  include BasicSpecialAtk
  include PostEffect

  def self.learn
    new(
      attack_name: 'Burn Up',
      type: Types::FIRE,
      pp: 5,
      category: :special,
      power: 130
      )
  end

  def precision
    pokemon.types.include?(Types::FIRE) ? 100 : 0
  end

  def post_effect(pokemon, targets)
    pokemon.types.delete(Types::FIRE)
    pokemon.types << Types::TYPELESS if pokemon.types.size < 1
    pokemon.lose_fire_type
    BattleLog.instance.log(MessagesPool.burn_up_msg(pokemon.name))
  end
end
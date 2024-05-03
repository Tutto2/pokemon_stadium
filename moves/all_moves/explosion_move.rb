require_relative "move"

class ExplosionMove < Move
  include BasicPhysicalAtk
  include PostEffect

  def self.learn
    new(
      attack_name: 'Explosion',
      type: Types::NORMAL,
      pp: 5,
      category: :physical,
      power: 250,
      target: 'all_except_self'
      )
  end

  private
  def post_effect(pokemon)
    pokemon.hp.decrease(pokemon.hp_total).to_i
    BattleLog.instance.log(MessagesPool.pok_fainted_msg(pokemon.name))
  end
end

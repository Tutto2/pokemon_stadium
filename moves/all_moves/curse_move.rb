require_relative "../move"

class CurseMove < Move
  include EffectDependsTarget
  include HpChange
  include StatChanges

  def self.learn
    new(
      attack_name: 'Curse',
      type: Types::GHOST,
      pp: 10,
      category: :status,
      target: 'one_opp'
      )
  end

  def alter_effect_activated?
    !pokemon.types.include?(Types::GHOST)
  end

  def status_effect(pokemon_target)
    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if pokemon.hp_value < (pokemon.hp_total / 2.0)
    lose_hp
    volatile_status_apply(pokemon_target, CurseStatus.get_cursed) if pokemon.hp_value >= (pokemon.hp_total / 2.0)
  end

  def value
    (pokemon.hp_total) * ( 1.0 / 2.0 )
  end

  def alter_effect
    atk_performed
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:spd, -1]
    ]
  end
end

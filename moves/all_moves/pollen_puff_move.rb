require_relative "../move"

class PollenPuffMove < Move
  include BasicSpecialAtk
  include EffectDependsTarget
  include HpChange

  def self.learn
    new(
      attack_name: 'Pollen Puff',
      type: Types::BUG,
      pp: 15,
      category: :special,
      power: 90,
      target: 'anyone_except_self'
      )
  end

  def alter_effect_activated?
    pokemon.allied?(targets[0])
  end

  def alter_effect
    atk_performed
    gain_hp(targets[0])
  end

  def value
    (pokemon.hp_total) * ( 1.0 / 2.0 )
  end
end

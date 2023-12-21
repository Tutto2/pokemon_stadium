require_relative "move"

class PollenPuffMove < Move
  include CanSelectTarget
  include BasicSpecialAtk
  include EffectDependsTarget
  include HpChange

  def self.learn
    new(
      attack_name: :pollen_puff,
      type: Types::BUG,
      pp: 15,
      category: :special,
      power: 90
      )
  end

  def alter_effect_activated?
    pokemon != pokemon_target
  end

  def alter_effect
    gain_hp(pokemon)
  end

  def value
    (pokemon.hp_total) * ( 1.0 / 2.0 )
  end
end
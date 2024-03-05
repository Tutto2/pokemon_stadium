require_relative "move"

class PainSplitMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: :pain_split,
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    BattleLog.instance.log(MessagesPool.pain_split_msg)

    if pokemon.hp_value < pokemon_target.hp_value
      gain_hp
      lose_hp(pokemon_target)
    elsif pokemon.hp_value > pokemon_target.hp_value
      lose_hp
      gain_hp(pokemon_target)
    else
      BattleLog.instance.log(MessagesPool.has_no_effect_msg)
    end
  end

  def value
    (( pokemon_target.hp_value - pokemon.hp_value ) / 2).to_i
  end
end
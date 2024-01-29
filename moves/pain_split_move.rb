require_relative "move"

class PainSplitMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: :pain_split,
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    BattleLog.instance.log(MessagesPool.pain_split_msg)
    difference = (( pokemon_target.hp_value - pokemon.hp_value ) / 2).to_i

    if pokemon.hp_value < pokemon_target.hp_value
      gain_hp(pokemon, difference)
      lose_hp(pokemon_target, difference)
    elsif pokemon.hp_value > pokemon_target.hp_value
      lose_hp(pokemon, difference)
      gain_hp(pokemon_target, difference)
    else
      BattleLog.instance.log(MessagesPool.has_no_effect_msg)
    end
  end
end
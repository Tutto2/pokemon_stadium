require_relative "move"

class EruptionMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :eruption,
      type: Types::FIRE,
      pp: 5,
      category: :special,
      target: 'all_opps'
      )
  end

  def power
    ( 150 * pokemon.hp_value ) / pokemon.hp_total
  end
end
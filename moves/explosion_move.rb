require_relative "move"

class ExplosionMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :explosion,
      type: Types::NORMAL,
      pp: 5,
      category: :physical,
      power: 250,
      target: 'all_except_self'
      )
  end

  private
  def secondary_effect
    pokemon.hp.decrease(pokemon.hp_total).to_i
  end
end
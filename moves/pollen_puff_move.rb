require_relative "move"

class PollenPuffMove < Move
  include BasicSpecialAtk

  def self.learn
    new(  attack_name: :pollen_puff,
          type: Types::BUG,
          category: :special,
          power: 90
        )
  end

  private
  def damage_effect
    if false && pokemon.ally?(pokemon_target)
      # heal_effect(0.5)
    else
      super
    end
  end
end
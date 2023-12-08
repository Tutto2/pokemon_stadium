require_relative "move"

class HurricaneMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(  attack_name: :hurricane,
          type: Types::FLYING,
          category: :special,
          power: 110,
          precision: 70
        )
  end

  private

  def secondary_effect
    volatile_condition_apply(pokemon_target, ConfusionStatus.get_confused(pokemon_target))
  end

  def trigger_chance
    0.3
  end
end
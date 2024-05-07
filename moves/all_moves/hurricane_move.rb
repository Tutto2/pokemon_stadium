require_relative "../move"

class HurricaneMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Hurricane',
      type: Types::FLYING,
      pp: 10,
      category: :special,
      power: 110,
      precision: 70
      )
  end

  private

  def secondary_effect
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end

  def trigger_chance
    0.3
  end
end

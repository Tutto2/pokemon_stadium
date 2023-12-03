require_relative "move"

class FlareBlitzMove < Move
  include BasicPhysicalAtk
  include HasRecoil
  include HasSecondaryEffect

  def self.learn
    new(  attack_name: :flare_blitz,
          type: Types::FIRE,
          category: :physical,
          power: 120
        )
  end

  private

  def recoil_factor
    1.0/3.0
  end

  def secondary_effect
    health_condition_apply(pokemon_target, BurnCondition.get_burn)
  end

  def trigger_chance
    0.1
  end
end
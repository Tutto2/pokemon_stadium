require_relative "../move"

class UTurnMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include SwitchAfterAttack

  def self.learn
    new(
      attack_name: 'U Turn',
      type: Types::BUG,
      pp: 20,
      category: :physical,
      power: 70
      )
  end
end

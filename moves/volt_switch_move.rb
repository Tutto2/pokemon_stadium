require_relative "move"

class VoltSwitchMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include SwitchAfterAttack

  def self.learn
    new(
      attack_name: :volt_switch,
      type: Types::ELECTRIC,
      pp: 20,
      category: :special,
      power: 70
      )
  end
end
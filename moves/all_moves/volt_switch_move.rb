require_relative "move"

class VoltSwitchMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect
  include SwitchAfterAttack

  def self.learn
    new(
      attack_name: 'Volt Switch',
      type: Types::ELECTRIC,
      pp: 20,
      category: :special,
      power: 70
      )
  end
end

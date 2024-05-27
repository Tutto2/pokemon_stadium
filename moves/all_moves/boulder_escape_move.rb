require_relative "../move"

class BoulderEscapeMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include SwitchAfterAttack

  def self.learn
    new(
      attack_name: 'Boulder Escape',
      type: Types::ROCK,
      pp: 10,
      category: :physical,
      power: 60
      )
  end
end
require_relative "../move"

class SacredSwordMove < Move
  include BasicPhysicalAtk
  include IgnoresEvassion
  include IgnoresStatChanges

  def self.learn
    new(
      attack_name: 'Sacred Sword',
      type: Types::FIGHTING,
      pp: 15,
      category: :physical,
      power: 90
      )
  end
end
require_relative "../move"

class TackleMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Tackle',
      type: Types::NORMAL,
      pp: 35,
      category: :physical,
      power: 40
      )
  end
end
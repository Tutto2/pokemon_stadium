require_relative "../move"

class PoltergeistMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Poltergeist',
      type: Types::GHOST,
      pp: 5,
      category: :physical,
      power: 110,
      precision: 90
      )
  end
end
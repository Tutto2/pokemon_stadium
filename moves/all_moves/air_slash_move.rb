require_relative "../move"

class AirSlashMove < Move
  include BasicSpecialAtk
  include CanFlinch

  def self.learn
    new(
      attack_name: 'Air Slash',
      type: Types::FLYING,
      pp: 15,
      category: :special,
      power: 75,
      precision: 95,
      )
  end
end
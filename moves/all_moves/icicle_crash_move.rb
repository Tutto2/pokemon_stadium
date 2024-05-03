require_relative "move"

class IcicleCrashMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include CanFlinch

  def self.learn
    new(
      attack_name: 'Icicle Crash',
      type: Types::ICE,
      pp: 10,
      category: :physical,
      power: 85,
      precision: 90
      )
  end
end

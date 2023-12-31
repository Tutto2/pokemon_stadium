require_relative "move"

class IcicleCrashMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include CanFlinch

  def self.learn
    new(
      attack_name: :icicle_crash,
      type: Types::ICE,
      pp: 10,
      category: :physical,
      power: 85,
      precision: 90
      )
  end
end
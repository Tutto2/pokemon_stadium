require_relative "move"

class ShadowSneakMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Shadow Sneak',
      type: Types::GHOST,
      pp: 30,
      category: :physical,
      priority: 1,
      power: 40
      )
  end
end

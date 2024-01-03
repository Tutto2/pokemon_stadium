require_relative "move"

class SpikyShieldMove < Move
  include PostEffect
  include ProtectiveMove
  attr_reader :successful

  def self.learn
    new(
      attack_name: :spiky_shield,
      type: Types::GRASS,
      pp: 10,
      category: :status,
      priority: 4
      )
  end
end
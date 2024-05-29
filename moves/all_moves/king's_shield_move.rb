require_relative "../move"

class KingsShieldMove < Move
  include PostEffect
  include ProtectiveMove
  attr_reader :successful

  def self.learn
    new(
      attack_name: "King's Shield",
      type: Types::STEEL,
      pp: 10,
      category: :status,
      priority: 4
      )
  end
end
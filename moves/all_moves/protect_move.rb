require_relative "../move"

class ProtectMove < Move
  include PostEffect
  include ProtectiveMove
  attr_reader :successful

  def self.learn
    new(
      attack_name: 'Protect',
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      priority: 4
      )
  end
end

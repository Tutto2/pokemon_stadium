require_relative "../move"

class ScorchingDefenseMove < Move
  include PostEffect
  include ProtectiveMove
  attr_reader :successful

  def self.learn
    new(
      attack_name: 'Scorching Defense',
      type: Types::FIRE,
      pp: 10,
      category: :status,
      priority: 4
      )
  end
end
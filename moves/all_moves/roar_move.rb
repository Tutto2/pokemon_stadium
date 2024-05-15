require_relative "../move"

class RoarMove < Move
  include MakesTargetSwitch

  def self.learn
    new(
      attack_name: 'Roar',
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      priority: -6,
      target: 'one_opp'
      )
  end
end

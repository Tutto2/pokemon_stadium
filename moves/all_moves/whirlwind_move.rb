require_relative "../move"

class WhirlwindMove < Move
  include MakesTargetSwitch

  def self.learn
    new(
      attack_name: 'Whirlwind',
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      priority: -6,
      target: 'one_opp'
      )
  end
end

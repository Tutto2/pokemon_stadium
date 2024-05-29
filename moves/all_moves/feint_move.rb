require_relative "../move"

class FeintMove < Move
  include BasicPhysicalAtk
  include HasPriorityEffect
  include ProtectionBreak

  def self.learn
    new(
      attack_name: 'Feint',
      type: Types::NORMAL,
      pp: 10,
      category: :physical,
      power: 30,
      priority: 2
      )
  end

  def priority_effect
    protect_evaluation(targets[0])
  end
end

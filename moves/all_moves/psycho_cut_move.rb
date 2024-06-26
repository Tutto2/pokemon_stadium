require_relative "../move"

class PsychoCutMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio

  def self.learn
    new(
      attack_name: 'Psycho Cut',
      type: Types::PSYCHIC,
      pp: 20,
      category: :physical,
      power: 70
      )
  end
end

require_relative "../move"

class NightSlashMove < Move
  include BasicPhysicalAtk
  include HasHighCritRatio

  def self.learn
    new(
      attack_name: 'Night Slash',
      type: Types::DARK,
      pp: 15,
      category: :physical,
      power: 70
      )
  end
end

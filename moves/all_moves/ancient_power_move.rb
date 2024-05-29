require_relative "../move"

class AncientPowerMove < Move
  include BasicSpecialAtk
  include StatChanges
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Ancient Power',
      type: Types::ROCK,
      pp: 5,
      category: :special,
      power: 60
      )
  end

  private
  def secondary_effect
    stat_changes
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:sp_atk, 1],
      [:sp_def, 1],
      [:spd, 1]
    ]
  end

  def trigger_chance
    0.1
  end
end
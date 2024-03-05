require_relative "move"

class GrowthMove < Move
  include StatChanges
  #Enhance by Sunlight

  def self.learn
    new(
      attack_name: :growth,
      type: Types::NORMAL,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes
  end

  def stat
    [
      [:sp_atk, 1],
      [:atk, 1]
    ]
  end
end
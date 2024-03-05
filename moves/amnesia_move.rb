require_relative "move"

class AmnesiaMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :amnesia,
      type: Types::PSYCHIC,
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
      [:sp_def, 2]
    ]
  end
end
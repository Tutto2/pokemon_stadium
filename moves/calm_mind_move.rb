require_relative "move"

class CalmMindMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Calm Mind',
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
      [:sp_atk, 1],
      [:sp_def, 1]
    ]
  end
end

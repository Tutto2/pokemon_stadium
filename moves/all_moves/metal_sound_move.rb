require_relative "move"

class MetalSoundMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: 'Metal Sound',
      type: Types::STEEL,
      pp: 40,
      category: :status,
      precision: 85,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:sp_def, -2]
    ]
  end
end

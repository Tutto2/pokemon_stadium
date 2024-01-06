require_relative "move"

class MetalSoundMove < Move
  include StatChanges

  def self.learn
    new(
      attack_name: :metal_sound,
      type: Types::STEEL,
      pp: 40,
      category: :status,
      precision: 85,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    stat_changes(pokemon_target)
  end

  def stat
    [
      [:sp_def, -2]
    ]
  end
end
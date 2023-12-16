require_relative "move"

class ThunderWaveMove < Move

  def self.learn
    new(
      attack_name: :thunder_wave,
      type: Types::ELECTRIC,
      pp: 20,
      category: :status,
      precision: 90
      )
  end

  private
  def status_effect
    if pokemon_target.types.any? { |type| type == Types::ELECTRIC || type == Types::GROUND }
      puts "It doesn't affects #{pokemon_target.name}"
    else
      health_condition_apply(pokemon_target, ParalysisCondition.get_paralyzed)
    end
  end
end
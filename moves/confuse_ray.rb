require_relative "move"

class ConfuseRayMove < Move
  def self.learn
    new(
      attack_name: :confuse_ray,
      type: Types::GHOST,
      pp: 10,
      category: :status,
      target: 'one_opp'
      )
  end
  
  private
  def status_effect(pokemon_target)
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end
end


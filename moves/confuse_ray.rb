require_relative "move"

class ConfuseRayMove < Move
  def self.learn
    new(  attack_name: :confuse_ray,
          type: Types::GHOST,
          category: :status
        )
  end
  
  private
  def status_effect
    health_condition_apply(pokemon_target, ConfusionStatus.get_confused(pokemon_target))
  end
end


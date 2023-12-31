require_relative "move"

class ConfuseRayMove < Move
  def self.learn
    new(
      attack_name: :confuse_ray,
      type: Types::GHOST,
      pp: 10,
      category: :status,
      target: :pokemon_target
      )
  end
  
  private
  def status_effect
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end
end


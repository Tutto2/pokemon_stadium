require_relative "../move"

module EffectDependsTarget
  def perform_normal_attack
    puts
    alter_effect_activated? ? alter_effect : execute
  end
  
  def alter_effect_activated?; end

  def alter_effect; end
end

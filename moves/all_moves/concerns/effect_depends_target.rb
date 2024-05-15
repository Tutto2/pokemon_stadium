require_relative "../../move"

module EffectDependsTarget
  def evaluate_special_perform
    if alter_effect_activated?
      alter_effect
    else
      execute
    end
  end
  
  def alter_effect_activated?; end

  def alter_effect; end
end

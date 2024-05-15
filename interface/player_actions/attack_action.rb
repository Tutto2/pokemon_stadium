require_relative "action"
require_relative "../trainer"

class AttackAction < Action
  def initialize(**args) 
    super(priority: args[:behaviour].priority, **args)
  end

  def perform
    BattleLog.instance.log(MessagesPool.leap)
    condition = user_pokemon.health_condition
    if condition == :frozen && ( condition.free_chance? || behaviour.can_defrost? )
      BattleLog.instance.log(MessagesPool.thawed_out_msg(user_pokemon.name))
      user_pokemon.health_condition = nil
    end
    user_pokemon.attack!(self) if !user_pokemon.fainted? || behaviour.attack_name == :future_sight
  end

  def enqueueable
    [extra_action, self].compact
  end

  def extra_action
    additional_move = behaviour.additional_move
    if additional_move
      self.dup.override_behaviour!(additional_move)
    end
  end

  def override_behaviour!(behaviour)
    @behaviour = behaviour
    @priority = behaviour.priority
    self
  end
end
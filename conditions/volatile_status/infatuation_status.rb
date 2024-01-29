require_relative "volatile_status"

class InfatuationStatus < VolatileStatus
  def self.get_infatuated
    new(
      name: :infatuated
      )
  end

  def unable_to_attack?
    if rand < 0.5
      BattleLog.instance.log(MessagesPool.infatuated_block_attack_msg)
      true
    else
      false
    end
  end
end
require_relative "../../move"

module DrainingAttack
  def calc_drain(dmg)
    (dmg * drain_factor).to_i
  end

  private
  def drain_factor
    attack_name == 'Draining Kiss' ? 0.75 : 0.5
  end

  def drain
    true
  end
end
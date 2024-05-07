require_relative "../../move"

module DrainingAttack
  def calc_drain(dmg)
    (dmg * drain_factor).to_i
  end

  private
  def drain_factor
    0.5
  end

  def drain
    true
  end
end
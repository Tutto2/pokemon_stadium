require_relative "../../move"

module HasRecoil
  def calc_recoil(dmg, hp)
    recoil_base(dmg, hp).to_f * recoil_factor
  end

  private
  def recoil_factor; end

  def recoil_base(dmg, hp)
    dmg
  end

  def recoil
    true
  end
end
require_relative "../move"

class StruggleMove < Move
  include BasicPhysicalAtk
  include HasRecoil

  def self.learn
    new(
      attack_name: 'Struggle',
      type: Types::NORMAL,
      pp: 1,
      category: :physical,
      power: 50,
      target: 'random_opp'
      )
  end

  def recoil_factor
    1.0/4.0
  end

  def recoil_base(dmg, hp)
    hp
  end
end

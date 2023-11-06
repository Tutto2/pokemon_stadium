require_relative "move"


class FlareBlitzMove < Move
  include BasicPhysicalAtk
  include HasRecoil
  # Can burn 10%
  # Breaks through frozen

  def self.learn
    new(  attack_name: :flare_blitz,
          type: Types::FIRE,
          category: :physical,
          power: 120
        )
  end

  private

  def recoil_factor
    1.0/3.0
  end
end
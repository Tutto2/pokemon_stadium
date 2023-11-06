require_relative "move"


class DoubleEdgeMove < Move
  include BasicPhysicalAtk
  include HasRecoil

  def self.learn
    new(  attack_name: :double_edge,
          type: Types::NORMAL,
          category: :physical,
          power: 120
        )
  end

  private

  def recoil_factor
    1.0/3.0
  end
end
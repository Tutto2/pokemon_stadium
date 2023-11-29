require_relative "move"

class DischargeMove < Move
  include BasicSpecialAtk
  # 30% parali

  def self.learn
    new(  attack_name: :discharge,
          type: Types::ELECTRIC,
          category: :special,
          power: 80
        )
  end
end
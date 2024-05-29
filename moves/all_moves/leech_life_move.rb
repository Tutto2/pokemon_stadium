require_relative "../move"

class LeechLifeMove < Move
  include BasicSpecialAtk
  include DrainingAttack

  def self.learn
    new(
      attack_name: 'Leech Life',
      type: Types::BUG,
      pp: 10,
      category: :physical,
      power: 80
    )
  end
end
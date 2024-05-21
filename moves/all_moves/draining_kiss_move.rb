require_relative "../move"

class DrainingKissMove < Move
  include BasicSpecialAtk
  include DrainingAttack

  def self.learn
    new(
      attack_name: 'Draining Kiss',
      type: Types::FAIRY,
      pp: 10,
      category: :special,
      power: 50
    )
  end
end

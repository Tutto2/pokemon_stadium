require_relative "move"

class GigaDrainMove < Move
  include BasicSpecialAtk
  include DrainingAttack

  def self.learn
    new(
      attack_name: :giga_drain,
      type: Types::GRASS,
      pp: 10,
      category: :special,
      power: 75
    )
  end
end
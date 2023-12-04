require_relative "move"

class PollenPuffMove < Move
  include BasicSpecialAtk
  # heal on self

  def self.learn
    new(  attack_name: :pollen_puff,
          type: Types::BUG,
          category: :special,
          power: 90
        )
  end

  private

end
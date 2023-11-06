require_relative "move"


class RecoverMove < Move
  include HpChange

  def self.learn
    new(  attack_name: :recover,
          type: Types::NORMAL,
          category: :status,
          precision: nil
        )
  end

  private
  def status_effect
    gain_hp
  end

  def value
    0.5 * pokemon.hp_total
  end
end
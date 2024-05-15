require_relative "../move"

class RecoverMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: 'Recover',
      type: Types::NORMAL,
      pp: 5,
      category: :status,
      precision: nil
      )
  end

  private
  def status_effect(pokemon_target)
    gain_hp
  end

  def value
    0.5 * pokemon.hp_total
  end
end

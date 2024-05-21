require_relative "../move"

class RoostMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: 'Roost',
      type: Types::FLYING,
      pp: 5,
      category: :status,
      precision: nil
      )
  end

  private
  def status_effect(pokemon_target)
    volatile_status_apply(pokemon, GroundedStatus.get_grounded(pokemon))
    pokemon.volatile_status[:grounded].change_pok_type(pokemon)
    gain_hp
  end

  def value
    0.5 * pokemon.hp_total
  end
end
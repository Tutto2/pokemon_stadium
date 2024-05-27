require_relative "volatile_status"

class OnFireStatus < VolatileStatus
  def self.get_on_fire(pokemon)
    new(
      name: :on_fire
      )
  end

  def change_pok_type(pokemon)
    pokemon.types << Types::FIRE if pokemon.types.size < 2
  end
end
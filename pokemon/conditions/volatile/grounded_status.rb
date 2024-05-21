require_relative "volatile_status"

class GroundedStatus < VolatileStatus
  def self.get_grounded(pokemon)
    new(
      name: :grounded,
      data: pokemon.types.dup,
      duration: 1
      )
  end

  def change_pok_type(pokemon)
    types = pokemon.types
    if types.include?(Types::FLYING)
      types.delete(Types::FLYING)
      types << Types::NORMAL if types.empty?
    end
  end

  def reinit_types(pokemon)
    old_types = volatile_status[:transformed].data
    pokemon.types = old_types
  end
end
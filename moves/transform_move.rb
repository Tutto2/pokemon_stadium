require_relative "move"

class TransformMove < Move
  def self.learn
    new(
      attack_name: :transform,
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      target: :pokemon_target
      )
  end

  private
  def status_effect
    volatile_status_apply(pokemon, TransformedStatus.get_transformed(pokemon))
    pokemon.volatile_status[:transformed].migrate_attributes(pokemon, pokemon_target.dup)
  end
end
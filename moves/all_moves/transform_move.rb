require_relative "move"

class TransformMove < Move
  def self.learn
    new(
      attack_name: 'Transform',
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    volatile_status_apply(pokemon, TransformedStatus.get_transformed(pokemon))
    pokemon.volatile_status[:transformed].migrate_attributes(pokemon, pokemon_target.dup)
  end
end

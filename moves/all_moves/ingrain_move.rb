require_relative "../move"

class IngrainMove < Move

  def self.learn
    new(
      attack_name: 'Ingrain',
      type: Types::GRASS,
      pp: 20,
      category: :status
      )
  end

  private
  def status_effect(pokemon_target)
    volatile_status_apply(pokemon, RootedStatus.get_rooted)
  end
end

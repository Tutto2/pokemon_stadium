require_relative "move"

class ProtectMove < Move
  include PostEffect
  attr_reader :successful

  def self.learn
    new(
      attack_name: :protect,
      type: Types::NORMAL,
      pp: 10,
      category: :status,
      priority: 4
      )
  end

  def chance_of_succeed
    if pokemon.metadata[:consecutive_hits].nil? || pokemon.metadata[:protect_used].nil?
      pokemon.init_count_of_consecutive_hits
      return 1
    else
      pokemon.add_consecutive_hits
      count = pokemon.metadata[:consecutive_hits]

      return ( (1.0 / 3.0) ** (count) )
    end
  end

  def status_effect
    if rand < chance_of_succeed
      pokemon.is_protected 
      @successful = true
    else 
      puts "The Attack has failed."
      @successful = false
    end
  end

  def post_effect(pokemon)
    pokemon.metadata.delete(:consecutive_hits) unless successful
    pokemon.metadata[:protect_used] = "Protect"
  end
end
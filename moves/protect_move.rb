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
    count = pokemon.metadata[:consecutive_hits].to_i

    (1.0 / 3.0) ** count
  end

  def status_effect
    if rand < chance_of_succeed
      puts chance_of_succeed
      pokemon.is_protected 
      @successful = true
    else 
      puts "The Attack has failed."
      @successful = false
    end
  end

  def post_effect(pokemon)
    successful ? pokemon.add_consecutive_hits : pokemon.metadata.delete(:consecutive_hits) 
  end
end
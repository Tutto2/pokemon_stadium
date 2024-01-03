require_relative "../move"

module ProtectiveMove
  def chance_of_succeed
    count = pokemon.metadata[:protection_consecutive_uses].to_i

    (1.0 / 3.0) ** count
  end

  def status_effect
    if rand < chance_of_succeed
      pokemon.is_protected(attack_name)
      @successful = true
    else 
      puts "The Attack has failed."
      @successful = false
    end
  end

  def post_effect(pokemon)
    successful ? pokemon.add_protection_consecutive_uses : pokemon.metadata.delete(:protection_consecutive_uses) 
  end
end

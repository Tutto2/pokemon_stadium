require_relative "volatile_status"

class InfatuationStatus < VolatileConditions
  def self.get_infatuated(pokemon)
    puts "#{pokemon.name} fell in love!"

    new(
      name: :infatuated
      )
  end

  def unable_to_attack?
    if rand < 0.5
      puts "Unable to attack due to love"
      return true
    else
      false
    end
  end
end
require_relative "volatile_status"

class SubstituteStatus < VolatileConditions
  def self.put_substitute(value, pokemon)
    puts "#{pokemon.name} put in a substitute!"

    new(
      name: :substitute,
      data: value
      )
  end
end
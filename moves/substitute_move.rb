require_relative "move"

class SubstituteMove < Move
  include HasSecondaryEffect
  include HpChange

  def self.learn
    new(
      attack_name: :substitute,
      type: Types::NORMAL,
      pp: 10,
      category: :status
      )
  end

  private

  def status_effect
    if pokemon.volatile_status[:substitute].nil?
      lose_hp 
    else
      puts "But it failed."
    end
  end

  def value
    ((pokemon.hp_total) * ( 1.0 / 4.0 )).to_i
  end

  def secondary_effect
    volatile_condition_apply(pokemon, SubstituteStatus.put_substitute(value.to_i, pokemon))
  end
end

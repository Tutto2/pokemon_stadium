require_relative "move"

class ClearSmogMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: :slear_smog,
      type: Types::POISON,
      pp: 15,
      category: :special,
      power: 50
      )
  end

  private
  def secondary_effect
    puts "All stat changes of #{pokemon_target.name} has been reset"
    pokemon_target.stats.each do |stat|
      stat.reset_stat
    end
  end
end
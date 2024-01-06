require_relative "move"

class PsychUpMove < Move
  include MigratePokInfo

  def self.learn
    new(
      attack_name: :psych_up,
      type: Types::NORMAL,
      pp: 10,
      category: :status
      )
  end

  def status_effect
    puts "#{pokemon.name} copied #{pokemon_target.name}'s stat changes"
    migrate_stat_stages
  end
end
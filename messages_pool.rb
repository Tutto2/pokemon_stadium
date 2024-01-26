require_relative 'pokemon/pokemon'

class MessagesPool
  def self.select_player_name(index)
    print "Player #{index}, select your name: "
  end

  def self.invalid_name_input
    puts "Invalid input, the name must be less than 10 characters"
    puts
  end

  def self.pokemon_selection(name)
    print "#{name} select a set of pokemon to battle: "
  end

  def self.invalid_pokemon_selection
    puts "Pick 1 to 6 pokemons, and provide valid indices. Try again."
    puts
  end

  def self.select_pokemon(name)
    print "#{name} select your pokemon: "
  end

  def self.invalid_option
    puts "Invalid option. Try again"
    puts
  end

  def self.turn(n)
    puts "############ turn #{n} ############"
  end

  def self.player_current_pokemon(name)
    puts "#{name}'s pokemon:"
  end

  def self.substitute_state(name, hp)
    puts "#{name}'s Substitute has #{hp} hp"
    puts
  end

  def self.pokemon_state(pok)
    puts "#{pok.name} - #{pok.hp_value} / #{pok.hp_total} hp (#{pok.types.map(&:to_s).join("/")}) #{pok.health_condition&.name}"
    pok.volatile_status.each { |k, v| puts "#{k}"}

    pok.stats.each do |stat|
      next if stat == :hp || stat == :spd
      puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    end
    puts "spd #{pok.actual_speed} / #{pok.spd.initial_value} / #{pok.spd.stage}"
    puts
  end
end
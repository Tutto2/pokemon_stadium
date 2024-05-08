require 'httparty'

class DataManager
  def self.view_teams_simple
    response = HTTParty.get("http://localhost:3000/teams?view=simple")

    if response.success?
      puts
      puts response.parsed_response
    end

    response.body
  end

  def self.view_team_detailed(id)
    response = HTTParty.get("http://localhost:3000/teams/#{id}?view=detailed")
    
    if response.success?
      puts
      items = response.parsed_response
  
      items.to_h.each do |item, value|
        if item == "pokemons"
          puts "pokemons:"
          value.each { |pok| puts pok }
        else
          print "#{item}: #{value}; "
        end
      end
    end

    puts
  end

  def self.get_team(id)
    HTTParty.get("http://localhost:3000/teams/#{id}?view=detailed").body
  end

  def team_converter(id)

  end
end
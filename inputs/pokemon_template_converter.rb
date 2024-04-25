data = File.readlines('pokemonlist.dat')

def data_process(data)
  fields = {}

  data.each do |field|
    next if field.include?("Stats")

    field_content = field.split(":")
    field_content = field_content.map(&:strip)
    if field_content.any?("Types")
      types = field_content[1].split(" / ")
      field_content = [[field_content[0]] + types].flatten
    end

    if field_content.any?("Types")
      case field_content.size
      when 2
        fields[field_content[0].downcase.to_sym] = [ field_content[1].upcase ]
      when 3
        fields[field_content[0].downcase.to_sym] = [ field_content[1].upcase, field_content[2].upcase]
      end
    elsif field_content.size == 2
      fields[field_content[0].to_sym] = field_content[1]
    else field_content.size == 1
      fields[:name] = field_content[0].capitalize
    end
  end

  fields
end

File.open('output.rb', 'w') do |file|
  line_number = 0

  while line_number < data.length
    each_pokemon = data[line_number, 9]
    pokemon = data_process(each_pokemon)
    file.puts pokemon

    line_number += 9
  end
end



# data.split(/spd:\s+\d{1,3}\n/)
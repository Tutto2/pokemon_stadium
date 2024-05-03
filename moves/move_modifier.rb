path = "./moves"

move_files = Dir.glob(File.join(path, "*.rb"))

move_files.each do |move|
  data = File.read(move)
  regex = /attack_name: :(\w+)/
  next if regex.match(data).nil?
  
  match = regex.match(data)[1]
  new_data = match.scan((/[a-z]+/)).map(&:capitalize).join(' ')
  modified_data = data.gsub!(regex, "attack_name: '#{new_data}'")

  File.open(move, "w") { |f| f.puts modified_data }
end
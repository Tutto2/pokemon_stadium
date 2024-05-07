require_relative "../../move"

module TakeDmgBack
  def return_dmg?
    true
  end

  def triggered?; end

  def dmg
    pokemon.metadata[:harm] * 2
  end
end
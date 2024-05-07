require_relative "../../move"

module BasicPhysicalAtk
  private

  def atk
    pokemon.atk
  end

  def dfn
    pokemon_target.def
  end
end
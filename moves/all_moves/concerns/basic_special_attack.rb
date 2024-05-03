require_relative "../move"

module BasicSpecialAtk
  private

  def atk
    pokemon.sp_atk
  end

  def dfn
    pokemon_target.sp_def
  end
end
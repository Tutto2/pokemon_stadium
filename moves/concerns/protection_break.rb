require_relative "../move"

module ProtectionBreak
  def breaks_protection?
    true
  end

  def protect_evaluation
    return execute unless pokemon_target.is_protected?

    puts "#{pokemon.name} broke through #{pokemon_target}'s protection"
    pokemon_target.protection_delete
    execute
  end
end
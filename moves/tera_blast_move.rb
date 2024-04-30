require_relative "move"

class TeraBlastMove < Move
  include BasicSpecialAtk
  include TypeChange
  # Changes category when Terastallized

  def self.learn
    new(
      attack_name: 'Tera Blast',
      type: Types::NORMAL,
      pp: 10,
      category: :special,
      power: 80
      )
  end

  private

  def atk
    pokemon.atk_value > pokemon.sp_atk_value ? pokemon.atk : pokemon.sp_atk
  end

  def type
    pokemon.types[0]
  end
end

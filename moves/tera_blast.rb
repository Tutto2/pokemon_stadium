require_relative "moves"
require_relative "concerns/move_modifiers"

class TeraBlastMove < Move
  include BasicSpecialAtk
  include TypeChange
  # Changes type and category when Terastallized

  def self.learn
    new(  attack_name: :tera_blast,
          type: Types::NORMAL,
          category: :special,
          power: 80
        )
  end

  self.type_change    

  private
  def atk
    pokemon.atk_value > pokemon.sp_atk_value ? pokemon.atk : pokemon.sp_atk
  end

  def new_type
    return pokemon.types[0]
  end
end
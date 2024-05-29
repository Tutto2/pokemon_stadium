require_relative "../move"

class SpectralStrikeMove < Move
  include BasicPhysicalAtk
  include HasSecondaryEffect
  include CanFlinch
  include PostEffect
  include StatChanges

  def self.learn
    new(
      attack_name: 'Spectral Strike',
      type: Types::GHOST,
      secondary_type: Types::STEEL,
      pp: 10,
      category: :physical,
      power: 120,
      precision: 90
      )
  end

  private

  def trigger_chance
    0.2
  end

  def post_effect(pokemon, targets)
    chance = targets[0].volatile_status[:flinched].nil? ? 0.1 : 0.5
    
    stat_changes if rand < chance
  end

  def stat
    [
      [:atk, 1],
      [:def, 1],
      [:sp_atk, 1],
      [:sp_def, 1],
      [:spd, 1]
    ]
  end
end

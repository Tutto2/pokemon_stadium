require_relative "../move"

class AlluringVoiceMove < Move
  include BasicSpecialAtk
  include HasSecondaryEffect

  def self.learn
    new(
      attack_name: 'Alluring Voice',
      type: Types::FAIRY,
      pp: 10,
      category: :special,
      power: 80
      )
  end

  def secondary_effect
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end

  def trigger_chance
    pokemon_target.was_buffed? ? 1 : 0
  end
end
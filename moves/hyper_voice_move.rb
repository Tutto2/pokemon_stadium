require_relative "move"

class HyperVoiceMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: :hyper_voice,
      type: Types::NORMAL,
      pp: 10,
      category: :special,
      power: 90
      )
  end
end
require_relative "../move"

class HyperVoiceMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Hyper Voice',
      type: Types::NORMAL,
      pp: 10,
      category: :special,
      power: 90,
      target: 'all_opps'
      )
  end
end

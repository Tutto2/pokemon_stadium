require_relative "../move"

class FickleBeamMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Fickle Beam',
      type: Types::DRAGON,
      pp: 5,
      category: :special
      )
  end

  def power
    rand > 0.3 ? 80 : 160
  end
end

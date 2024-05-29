require_relative "../move"

class DazzlingGleamMove < Move
  include BasicSpecialAtk

  def self.learn
    new(
      attack_name: 'Dazzling Gleam',
      type: Types::FAIRY,
      pp: 5,
      category: :special,
      power: 80,
      target: 'all_opps'
      )
  end
end
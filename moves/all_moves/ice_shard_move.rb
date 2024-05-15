require_relative "../move"

class IceShardMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Ice Shard',
      type: Types::ICE,
      pp: 30,
      category: :physical,
      priority: 1,
      power: 40
      )
  end
end

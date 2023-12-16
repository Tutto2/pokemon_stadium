require_relative "move"

class IceShardMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: :ice_shard,
      type: Types::ICE,
      pp: 30,
      category: :physical,
      priority: 1,
      power: 40
      )
  end
end
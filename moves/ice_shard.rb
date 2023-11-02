require_relative "moves"

class IceShardMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(  attack_name: :ice_shard,
          type: Types::ICE,
          category: :physical,
          priority: 1,
          power: 40
        )
  end
end
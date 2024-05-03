require_relative "pokemon"
require_relative "../moves/move"

module TargetManagement
  def assing_target(attack, target_positions)
    tar = attack.target
    battle_type = trainer.battleground.battle_type

    return [self] if tar == 'self' || attack.return_dmg?
    return [] if tar == 'teammate' && battle_type != 'double'

    field_positions = trainer.battleground.field.positions
    self_position_index = field_position

    if battle_type == 'single'
      self_position_index.odd? ? [field_positions[2]] : [field_positions[1]]
    elsif battle_type == 'double' && target_positions != nil && target_positions.size == 1
      pos = target_positions[0]
      if pos == 3
        assing_teammate(field_positions, self_position_index)
      else
        self_position_index.odd? ? [field_positions[pos * 2]] : [field_positions[(pos * 2) - 1]]
      end
    else
      special_targeting(tar, field_positions, self_position_index)
    end
  end

  def special_targeting(tar, field_positions, self_position_index)
    case tar
    when 'all_opps' then assing_all_opps(field_positions, self_position_index)
    when 'random_opp' then assing_rand_opp(field_positions, self_position_index)
    when 'teammate' then assing_teammate(field_positions, self_position_index)
    when 'all_except_self' then assign_all(field_positions, self_position_index)
    end
  end

  def assing_all_opps(field_positions, self_position_index)
    targets = []

    if self_position_index.odd?
      targets << field_positions[2]
      targets << field_positions[4]
    else
      targets << field_positions[1]
      targets << field_positions[3]
    end

    targets
  end

  def assing_rand_opp(field_positions, self_position_index)
    targets = []

    x = rand(1..2)
    if self_position_index.odd?
      targets << field_positions[x * 2]
    else
      targets << field_positions[(x * 2) - 1]
    end

    targets
  end

  def assing_teammate(field_positions, self_position_index)
    targets = []

    teammate_mapping = {
      1 => 3,
      3 => 1,
      2 => 4,
      4 => 2
    }
    
    teammate_index = teammate_mapping[self_position_index]
    pok = field_positions[teammate_index]
    targets << pok

    targets
  end

  def assign_all(field_positions, self_position_index)
    targets = []

    field_positions.each do |index, pok|
      next if index == self_position_index
      targets << pok
    end
    
    targets
  end
end

require_relative "move"

class CopycatMove < Move
  include HpChange

  def self.learn
    new(
      attack_name: :copycat,
      type: Types::NORMAL,
      pp: 20,
      category: :status,
      target: 'one_opp'
      )
  end

  private
  def status_effect(pokemon_target)
    last_attack = pokemon.trainer.battleground.attack_list["last_attack"]
    field_positions = pokemon.trainer.battleground.field.positions
    pok_position = field_positions.find { |i, pok| pok == pokemon }

    return BattleLog.instance.log(MessagesPool.attack_failed_msg) if last_attack.nil?

    last_attack.assing_target if last_attack.target.nil?

    if last_attack.target == 'self'
      last_attack.perform_attack(pokemon, [pokemon])
    elsif last_attack.target == 'teammate'
      teammate_mapping = {
        1 => 3,
        3 => 1,
        2 => 4,
        4 => 2
      }

      teammate_index = teammate_mapping[pok_position[0]]
      teammate = field_positions[teammate_index]
      last_attack.perform_attack(pokemon, [teammate])
    elsif last_attack.target == 'all_opps'
      targets = []
      if pok_position[0].odd?
        targets << field_positions[2]
        targets << field_positions[4]
      else
        targets << field_positions[1]
        targets << field_positions[3]
      end

      last_attack.perform_attack(pokemon, targets)
    elsif last_attack.target == 'random_opp'
      targets = []
      x = rand(1..2)
      if pok_position[0].odd?
        targets << field_positions[x * 2]
      else
        targets << field_positions[(x * 2) - 1]
      end

      last_attack.perform_attack(pokemon, targets)
    elsif last_attack.target == 'all_except_self'
      targets = []
      field_positions.each do |index, pok|
        next if pok == pokemon
        targets << pok
      end
      last_attack.perform_attack(pokemon, targets)
    else
      last_attack.perform_attack(pokemon, [pokemon_target])
    end
  end
end
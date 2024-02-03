require_relative 'moves/move'
require_relative 'pokemon/pokemon'
require_relative 'trainer'

class MessagesPool
  def invalid_game_settings(players_num, battle_type)
    if battle_type == 'double' && players_num == 3
      puts "Invalid game settings, if battle type is set to 'double', then the number of players must be even"
    else
      puts "Invalid game settings, must select only 2 - 4 players"
    end
  end

  def self.select_player_name(index)
    print "Player #{index}, select your name: "
  end

  def self.select_teammate_name(index)
    case index  
    when 1
      puts "Which are the members of the first team?"
    when 3
      puts "Which are the members of the second team?"
    end

    print "Player #{index}, select your name: "
  end

  def self.invalid_name_input
    puts "Invalid input, the name must be less than 10 characters"
    puts
  end

  def self.pokemon_selection(name)
    print "#{name} select a set of pokemon to battle: "
  end

  def self.invalid_pokemon_selection
    puts "Pick 1 to 6 pokemons, and provide valid indices. Try again."
    puts
  end

  def self.select_pokemon(name, battle_type, players)
    if battle_type == 'double' && players.size == 2
      print "#{name} select two pokemons to battle: "
    else
      print "#{name} select your pokemon: "
    else
    end
  end

  def self.invalid_option_on_doubles
    puts "Please select two pokemon, providing two different valid indices. Try again:"
  end

  def self.invalid_option
    puts "Invalid option. Try again"
    puts
  end

  def self.turn(n)
    puts
    puts "############ turn #{n} ############"
    puts
  end

  def self.player_current_pokemons(name, battle_type)
    if battle_type == 'single'
      puts "#{name}'s pokemon:"
    else
      puts "#{name}'s pokemons:"
    end
  end

  def self.opponents_index
    print "Pick a target: "
  end

  def self.posible_targets(pok, index)
    puts "#{index}- #{pok.to_s}  #{pok.hp_value} / #{pok.hp_total} hp"
  end

  def self.substitute_state(name, hp)
    puts "#{name}'s Substitute has #{hp} hp"
    puts
  end

  def self.pokemon_state(pok)
    puts "#{pok.name} - #{pok.hp_value} / #{pok.hp_total} hp (#{pok.types.map(&:to_s).join("/")}) #{pok.health_condition&.name}"
    pok.volatile_status.each { |k, v| puts "#{k}"}

    # pok.stats.each do |stat|
    #   next if stat == :hp || stat == :spd
    #   puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    # end
    # puts "spd #{pok.actual_speed} / #{pok.spd.initial_value} / #{pok.spd.stage}"
    puts
  end

  def self.display_action_index(trainer, user_pokemon)
    puts "1- Attack"
    puts "2- Change pokemon"
    puts
    print "#{trainer.name}, what do you want to do with #{user_pokemon.to_s}?: "
  end

  def self.unable_to_escape_alert(pok_name)
    puts "#{pok_name} can't escape of his bound"
    puts
  end

  def self.no_remaining_moves_alert(pok_name)
    puts "#{pok_name} has no left moves."
    puts
  end

  def self.go_back_index(list)
    puts "#{ (list.length) + 1 }- Go back"
    puts
  end

  def self.select_attack_index
    print 'Enter the attack number: '
  end

  def self.banned_attack_alert
    puts "This move can't be used twice in a row"
    puts
  end

  def self.unable_to_use_attack_alert
    puts "Can't use that attack"
    puts
  end

  def self.no_remaining_pp_alert(attack_name)
    puts "#{attack_name} has no remaining PP"
    puts
  end

  def self.select_pokemon_index(trainer_name)
    print "#{trainer_name} select your pokemon: "
  end

  def self.switch_action_msg(next_pok_name)
    "#{next_pok_name} got out to battle!"
  end

  def self.broke_protection_msg(pok_name, target)
    "#{pok_name} broke through #{target}'s protection"
  end

  def self.thawed_out_msg(pok_name)
    "#{pok_name} got thawed out"
  end

  def self.future_sight_msg(pok_name)
    "#{pok_name} has foreseen an attack."
  end

  def self.sound_based_blocked_msg(pok_name)
    "#{pok_name} can't use sound-based moves for a while"
  end

  def self.woke_up_msg(pok_name)
    "#{pok_name} woke up!" 
  end

  def self.status_wore_off_msg(status_name)
    "#{status_name} wore off!"
  end

  def self.unable_to_move_msg(name, health_condition_name)
    "#{name} is #{health_condition_name}, it was unable to move"
  end

  def self.flinched_msg(pok_name)
    "#{pok_name} flinch after being attacked"
  end
  
  def self.confused_msg(pok_name)
    "#{pok_name} is confused."
  end
  
  def self.confusion_dmg_msg(pok_name, dmg)
    "#{pok_name} hurt itself in its confusion (#{dmg})"
  end
  
  
  def self.infatuated_msg(pok_name)
    "#{pok_name} is in love."
  end
  
  def self.infatuated_block_attack_msg
    "Unable to attack due to love"
  end
  
  def self.no_pp_during_attack(pok_name, attack_name)
    "#{pok_name} used #{attack_name}, but it has no remaining PP"
  end
  
  def self.attack_being_used_msg(pok_name, move)
    "#{pok_name} used #{move.attack_name} (#{move.category}, type: #{move.type})"
  end

  def self.stat_variation_msg(target, stat, text)
    "#{target}'s #{stat} #{text}"
  end
  
  def self.stat_at_max_msg(stat_name)
    "#{stat_name} won't go any higher!"
  end

  def self.stat_at_min_msg(stat_name)
    "#{stat_name} won't go any lower!"
  end

  def self.no_hp_effect_msg(target)
    "It has no effect on #{target}'s HP"
  end

  def self.recover_msg(target, value)
    "#{target} has recover #{value} hp"
  end

  def self.attack_failed_msg
    "But it failed."
  end

  def self.switch_failed_alert(player, attack_name)
    "#{player} has no remaining pokemon, #{attack_name} failed."
  end

  def self.unable_to_switch_msg(player, pok_name)
    "#{player} has no pokemon remaining, #{pok_name} couldn't switch"
  end

  def self.immunity_msg(pok_name)
    "#{pok_name} it's immune"
  end

  def self.critical_hit_msg
    "It's a critical hit!"
  end

  def self.was_protected_msg(pok_name)
    "#{pok_name} protected itself."
  end

  def self.spiky_shield_msg(pok_name, damage)
    "#{pok_name} has lost #{damage} HP due to Spiky Shield"
  end

  def self.clear_smog_msg(target)
    "All stat changes of #{target} has been reset"
  end

  def self.endure_msg(pok_name)
    "#{pok_name} braced itself!"
  end

  def self.recharge_msg(pok_name, attack_name)
    "#{pok_name} is recharging after using #{attack_name}"
  end

  def self.vulnerable_msg(pok_name)
    "#{pok_name} is vulnerable"
  end

  def self.no_dmg_msg(pok_name)
    "#{pok_name} has not recieved any damage"
  end

  def self.has_no_effect_msg
    "It hasn't effect"
  end

  def self.no_affect_target_msg(target)
    "It doesn't affects #{target}"
  end

  def self.pain_split_msg
    "The battlers shared their pain"
  end

  def self.phantom_force_msg(pok_name)
    "#{pok_name} vanished"
  end

  def self.psych_up_msg(pok_name, target)
    "#{pok_name} copied #{target}'s stat changes"
  end

  def self.shell_trap_msg(pok_name)
    "#{pok_name} set a shell trap."
  end

  def self.skull_bash_msg(pok_name)
    "#{pok_name} lowered his head"
  end

  def self.charging_atk_msg
    "The attack is charging"
  end

  def self.spite_msg(target, previous_action)
    "It reduced the PP of #{target}'s #{previous_action} by 4"
  end

  def self.attack_power_msg(power)
    "power: #{power}"
  end

  def self.substitute_dmg_recieved_msg(pok_name, dmg)
    "#{pok_name}'s substitute has recieved #{dmg} damage"
  end

  def self.substitute_immune_msg(pok_name, attack_name)
    "#{attack_name} does not affect #{pok_name}'s Substitute"
  end

  def self.substitute_broke_msg(pok_name)
    "#{pok_name}'s substitute broke!"
  end

  def self.endure_msg(pok_name)
    "#{pok_name} endured the hit!"
  end

  def self.dmg_recieved_msg(pok_name, dmg)
    "#{pok_name} has recieved #{dmg} damage"
  end

  def self.hp_restored_msg(pok_name, value)
    "#{pok_name} restored #{value} HP"
  end
  
  def self.recoil_msg(pok_name, recoil_dmg)
    "#{pok_name} has recieved #{recoil_dmg} of recoil damage"
  end

  def self.focus_punch_msg(pok_name) 
    "#{pok_name} is focusing."
  end

  def self.ineffective_msg
    "It's ineffective"
  end

  def self.super_effective_msg
    "It's super effective"
  end

  def self.effective_msg
    "It's effective"
  end

  def self.multi_hit_msg(pok_name, strikes)
    "#{pok_name} received #{strikes} hits"
  end

  def self.condition_apply_fail_msg(pok_name, condition)
    "#{pok_name} cannot get #{condition}"
    puts
  end

  def self.condition_apply_msg(pok_name, condition)
    "#{pok_name} got #{condition}!"
  end

  def self.confusion_apply(target)
    "#{target} got confused!"
  end

  def self.curse_apply(pok_name, target)
    "#{pok_name} cut his own HP and laid a curse on #{target}"
  end

  def self.infatuation_apply(target)
    "#{target} fell in love!"
  end
  
  def self.seed_apply(target)
    "#{target} was seeded"
  end
  
  def self.substitute_apply(pok_name)
    "#{pok_name} put in a substitute!"
  end
  
  def self.bound_apply(target)
    "#{target} was trapped!"
  end

  def self.transform_apply(pok_name, target)
    "#{pok_name} transformed into #{target}!"
  end

  def self.perish_song_apply_msg
    "All pokemon hearing the song will faint in three turns"
  end

  def self.perish_song_effect_msg(pok_name)
    "#{pok_name} has lost all its HP due to Perish Song"
  end

  def self.poison_dmg_msg(pok_name, dmg)
    "#{pok_name} is hurt by poison! (#{dmg})"
  end

  def self.burn_dmg_msg(pok_name, dmg)
    "#{pok_name} is hurt by its burn! (#{dmg})"
  end

  def self.bound_dmg_msg(pok_name, status_name, dmg)
    "#{pok_name} is hurt by #{status_name}! (#{dmg})"
  end

  def self.curse_dmg_msg(pok_name, dmg)
    "#{pok_name} is afflicted by the curse! (#{dmg})"
  end

  def self.seeded_dmg_msg(pok_name, dmg)
    "#{pok_name} health is sapped by Leech Seed! (#{dmg})"
  end

  def self.lose_hp_msg(target, value)
    "#{target} has lost #{value} hp"
  end

  def self.pok_fainted_msg(pok_name)
    "#{pok_name} has fainted"
  end

  def self.final_hp_msg(pok_name, hp)
    "#{pok_name} now has #{hp} hp"
  end

  def self.leap
    puts
  end
  
  def self.declare_winner(player)
    "*-*-*-*-* #{player.upcase} HAS WON!! *-*-*-*-*"
  end

  def self.declare_two_winners(winners)
    "*-*-*-* #{winners[0].name.upcase} AND #{winners[1].name.upcase} HAS WON!! *-*-*-*"
  end
end
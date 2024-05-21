require_relative '../moves/move'
require_relative '../pokemon/pokemon'
require_relative 'battle_log'

class MessagesPool
  def self.interface_index
    BattleLog.instance.log("\n")
    BattleLog.instance.log("1- Start a battle")
    BattleLog.instance.log("2- Load data")
  end
  
  def self.invalid_game_settings(players_num, battle_type)
    if battle_type == 'double' && players_num == 3
      BattleLog.instance.log("Invalid game settings, when 'double' battle is set the number of players must be even")
    elsif battle_type == 'royale' && players_num == 2
      BattleLog.instance.log("Invalid game settings, when 'royale' battle is set the number of players must more than 2")
    else
      BattleLog.instance.log("Invalid game settings, must select only 2 - 4 players")
    end
    BattleLog.instance.display_messages
  end

  def self.select_first_action
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Select an option: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.loading_index
    BattleLog.instance.log("1- Load team")
    BattleLog.instance.log("2- View teams")
    BattleLog.instance.log("3- Load pokemons")
    BattleLog.instance.log("4- Go back")
  end

  def self.load_team_msg
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Please, wirte the name of the file with your team info")
    BattleLog.instance.log("(the file must be inside 'interface/input_management' directory): ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.load_pokemons_msg
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Please wirte the name of the file containing the Pokemon info:")
    BattleLog.instance.log("(the file must be inside 'interface/input_management' directory): ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.loading_error(file_name)
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Error! File '#{file_name}' not found in the specified directory")
    BattleLog.instance.log("Put a copy on the following path: 'root/interface/input_management/file.pkteam'")
    BattleLog.instance.display_messages
  end

  def self.reading_error
    BattleLog.instance.log("\n")
    BattleLog.instance.log('file contains unparsable characters')
    BattleLog.instance.display_messages
  end

  def self.successful_load_msg
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Your data has been successfully saved.")
    BattleLog.instance.display_messages
  end

  def self.view_team_index
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Type the index of a team to see more details (type anything else to go back): ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.team_index_error_msg(teams_count)
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Team not found, please select a number ")
    BattleLog.instance.display_messages
  end

  def self.view_team_error
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Error, please verify the url at './interface/data_manager.rb'")
    BattleLog.instance.display_messages
  end

  def self.invalid_input_msg
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Invalid inputs. Try again")
    BattleLog.instance.display_messages
  end

  def self.battle_settings_options
    BattleLog.instance.log("\n")
    BattleLog.instance.log("1- Single Battle")
    BattleLog.instance.log("2- Double Battle")
    BattleLog.instance.log("3- Battle Royale")
    BattleLog.instance.log("4- Go Back")
  end
  
  def self.select_battle_settings
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Select the index of a battle format: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.select_players_num
    BattleLog.instance.log("Please select how many players would participate (type 0 to go back): ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.select_player_name(index)
    BattleLog.instance.log("Player #{index}, select your name: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.select_teammate_name(index)
    case index  
    when 1
      BattleLog.instance.log("Which are the members of the first team?")
    when 3
      BattleLog.instance.log("Which are the members of the second team?")
    end

    BattleLog.instance.log("Player #{index}, select your name: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.invalid_name_input
    BattleLog.instance.log("Invalid input, the name must be less than 10 characters")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.team_selection_index
    BattleLog.instance.log("1- Select a pre-set team")
    BattleLog.instance.log("2- Build your own team")
  end
  
  def self.action_selection(name)
    BattleLog.instance.log("\n")
    BattleLog.instance.log("#{name}, select an option: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.pre_set_team_index
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Select a team by typing its index number. To view more details, add a question mark (?) at the end")
    BattleLog.instance.log("For exmple, '3' to choose a team or '3?' for additional information. ('0' to go back): ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.select_detailed_team
    BattleLog.instance.log("\n")
    BattleLog.instance.log("Type 'select' to choose this team, type any other key to go back: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.pokemon_selection(name)
    BattleLog.instance.log("#{name} select a set of pokemon to battle: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.invalid_pokemon_selection
    BattleLog.instance.log("Pick 1 to 6 pokemons, and provide valid indices. Try again.")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.select_pokemon(name, battle_type, players)
    if battle_type == 'double' && players.size == 2
      BattleLog.instance.log("#{name} select two pokemons to battle: ", :fillable)
    else
      BattleLog.instance.log("#{name} select your pokemon: ", :fillable)
    end
    BattleLog.instance.display_messages
  end

  def self.invalid_option_on_doubles
    BattleLog.instance.log("Please select two pokemon, providing two different valid indices. Try again:")
    BattleLog.instance.display_messages
  end

  def self.invalid_option
    BattleLog.instance.log("Invalid option. Try again")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.turn(n)
    BattleLog.instance.log("\n")
    BattleLog.instance.log("############ turn #{n} ############")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.first_team_msg
    BattleLog.instance.log("First team pokemons:")
  end

  def self.second_team_msg
    BattleLog.instance.log("Second team pokemons:")
  end

  def self.player_current_pokemons(name, battle_type, players_num)
    if battle_type == 'double' && players_num == 2
      BattleLog.instance.log("#{name}'s pokemons:")
    else
      BattleLog.instance.log("#{name}'s pokemon:")
    end
    BattleLog.instance.display_messages
  end

  def self.has_no_remaining_poks(player)
    BattleLog.instance.log("#{player.name} has no remaining pokemons")
    BattleLog.instance.display_messages
  end

  def self.targets_index
    BattleLog.instance.log("Pick a target: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.posible_targets(pok, index)
    BattleLog.instance.log("#{index}- #{pok.to_s} #{pok.hp_value} / #{pok.hp_total} hp")
    BattleLog.instance.display_messages
  end

  def self.substitute_state(name, hp)
    BattleLog.instance.log("#{name}'s Substitute has #{hp} hp")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.trainer_name(pok)
    BattleLog.instance.log("#{pok.trainer.name}'s pokemon:")
  end

  def self.pokemon_state(pok)
    if pok.nickname == pok.name
      BattleLog.instance.log("#{pok.name} - #{pok.hp_value} / #{pok.hp_total} hp (#{pok.types.map(&:to_s).join("/")}) #{pok.health_condition&.name}")
    else
      BattleLog.instance.log("#{pok.nickname} (#{pok.name}) - #{pok.hp_value} / #{pok.hp_total} hp (#{pok.types.map(&:to_s).join("/")}) #{pok.health_condition&.name}")
    end
    pok.volatile_status.each { |k, v| BattleLog.instance.log("#{k}")}

    pok.stats.each do |stat|
      next if stat == :hp
      # BattleLog.instance.log("#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}")
      BattleLog.instance.log("#{stat.name} #{stat.stage}") if stat.stage != 0
    end
    # BattleLog.instance.log("spd #{pok.actual_speed} / #{pok.spd.initial_value} / #{pok.spd.stage}")
    # BattleLog.instance.log("position: #{pok.field_position}")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.display_action_index(trainer, user_pokemon)
    BattleLog.instance.log("1- Attack")
    BattleLog.instance.log("2- Change pokemon")
    BattleLog.instance.log("\n")
    BattleLog.instance.log("#{trainer.name}, what do you want to do with #{user_pokemon.to_s}?: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.unable_to_escape_alert(pok)
    if pok.volatile_status[:bound].nil?
      BattleLog.instance.log("#{pok.name} can't escape due to its roots")  
    else
      BattleLog.instance.log("#{pok.name} can't escape of its bound")
    end
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.no_remaining_moves_alert(pok_name)
    BattleLog.instance.log("#{pok_name} has no left moves.")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.go_back_index(list)
    BattleLog.instance.log("#{ (list.length) + 1 }- Go back")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.select_attack_index
    BattleLog.instance.log('Enter the attack number: ', :fillable)
    BattleLog.instance.display_messages
  end

  def self.banned_attack_alert
    BattleLog.instance.log("This move can't be used twice in a row")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.unable_to_use_attack_alert
    BattleLog.instance.log("Can't use that attack")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.no_remaining_pp_alert(attack_name)
    BattleLog.instance.log("#{attack_name} has no remaining PP")
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
  end

  def self.select_pokemon_index(trainer_name)
    BattleLog.instance.log("#{trainer_name} select your pokemon: ", :fillable)
    BattleLog.instance.display_messages
  end

  def self.poke_index(pok, index)
    "#{index}- #{pok.to_s}"
  end

  def self.atk_index(atk, index)
    "#{index}- #{atk.attack_name} / #{atk.pp.to_i} PP"
  end

  def self.menu_leap
    BattleLog.instance.log("\n")
    BattleLog.instance.display_messages
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

  def self.remaining_turns_msg(turns, atk_name)
    "Turns remaining #{turns} for #{atk_name} to execute"
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

  def self.focus_energy_msg(pok_name)
    "#{pok_name} is getting pumped"
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

  def self.splash_msg
    "But nothing happened!"
  end

  def self.recover_msg(target, value)
    "#{target} has recover #{value} hp"
  end

  def self.attack_failed_msg
    "But it failed."
  end

  def self.meteor_beam_msg(pok_name)
    "#{pok_name} is overflowing with space power!"
  end

  def self.attack_missed_msg(pok)
    "#{pok.name} has missed"
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

  def self.root_apply(pok_name)
    "#{pok_name} planted it's roots"
  end

  def self.rooted_heal_msg(pok_name)
    "#{pok_name} absorbed nutrients with his roots"
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

  def self.fly_msg(pok_name)
    "#{pok_name} flew  up high"
  end

  def self.psych_up_msg(pok_name, target)
    "#{pok_name} copied #{target}'s stat changes"
  end

  def self.shell_trap_msg(pok_name)
    "#{pok_name} set a shell trap."
  end

  def self.shell_trap_fail_msg(pok_name)
    "The trap didn't trigger, #{pok_name} couldn't move"
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

  def self.endured_msg(pok_name)
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

  def self.focus_punch_fail_msg(pok_name) 
    "#{pok_name} lost its focus and couldn't move"
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
    "#{pok_name} cannot get #{condition}\n"
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
    "\n"
  end
  
  def self.declare_winner(player)
    BattleLog.instance.log("*-*-*-*-* #{player.upcase} HAS WON!! *-*-*-*-*")
    BattleLog.instance.display_messages
  end

  def self.declare_two_winners(winners)
    BattleLog.instance.log("*-*-*-* #{winners[0].name.upcase} AND #{winners[1].name.upcase} HAS WON!! *-*-*-*")
    BattleLog.instance.display_messages
  end
end
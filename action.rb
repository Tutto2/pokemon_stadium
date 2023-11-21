require_relative "pokemon/pokemon"

class Action
  attr_reader :action_type, :priority, :action, :speed
  
  def initialize(action_type: , priority: 0, action: nil, speed: nil)
    @action_type = action_type
    @priority = priority
    @action = action
    @speed = speed
  end

  def perform_action
    case action_type
    when :switch_action
      perform_switch
    when :atk_action
      perform_attack
    when :additional_action
      additional_action
    end
  end

  private
  
  def perform_switch(action_message)
    next_pokemon = action_message[:next_pokemon]
    player = action_message[:player]
      
    if player == :one
      @current_pokemon_p1 = next_pokemon
    elsif player == :two
      @current_pokemon_p2 = next_pokemon
    end
  end

  def perform_attack(action_message)
    attk_num = action_message[:attk_num]
    player = action_message[:player]
      
    if player == :one
      target_pokemon = @current_pokemon_p2
      current_pokemon = @current_pokemon_p1
    elsif player == :two
      target_pokemon = @current_pokemon_p1
      current_pokemon = @current_pokemon_p2
    end

    current_pokemon.attack!(attk_num, target_pokemon) unless current_pokemon.fainted?
  end
end
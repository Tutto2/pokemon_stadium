require_relative "move"

class SweetKissMove < Move
  def self.learn
    new(
      attack_name: :sweet_kiss,
      type: Types::FAIRY,
      pp: 10,
      category: :status,
      precision: 75,
      target: 'one_opp'
      )
  end
  
  private
  def status_effect(pokemon_target)
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end
end
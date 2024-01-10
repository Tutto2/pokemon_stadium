require_relative "move"

class SweetKissMove < Move
  def self.learn
    new(
      attack_name: :sweet_kiss,
      type: Types::FAIRY,
      pp: 10,
      category: :status,
      precision: 75,
      target: :pokemon_target
      )
  end
  
  private
  def status_effect
    volatile_status_apply(pokemon_target, ConfusionStatus.get_confused)
  end
end
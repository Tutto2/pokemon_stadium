require_relative "../move"

class SplashMove < Move
  include BasicPhysicalAtk

  def self.learn
    new(
      attack_name: 'Splash',
      type: Types::NORMAL,
      pp: 40,
      category: :status,
      )
  end

  private
  def status_effect(pokemon_target)
    BattleLog.instance.log(MessagesPool.splash_msg)
  end
end
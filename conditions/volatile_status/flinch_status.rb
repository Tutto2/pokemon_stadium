require_relative "volatile_status"

class FlinchStatus < VolatileConditions
  def self.get_flinched
    new(
      name: :flinched,
      duration: 1
      )
  end

  def unable_to_attack?
    true
  end
end
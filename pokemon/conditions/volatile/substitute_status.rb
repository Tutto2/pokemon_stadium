require_relative "volatile_status"

class SubstituteStatus < VolatileStatus
  def self.put_substitute(value)
    new(
      name: :substitute,
      data: value
      )
  end
end
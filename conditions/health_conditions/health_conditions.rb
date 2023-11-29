require_relative "../../pokemon/stats"
require_relative "../../pokemon/pokemon"
require_relative "../../types/type_factory"

class HealthConditions
  attr_accessor :name, :inmune_type

  def initialize(name:, inmune_type: nil)
    @name = name
    @inmune_type = inmune_type
  end

  def dmg_effect(pokemon); end

  def fail_change; end

  def stat_nerf; end

  def ==(other)
    name == other
  end
end
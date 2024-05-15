require_relative "../../move"

module HasCustomTable
  def power
    range, power = table.find { |(range, power)| range.include?(calculation_stat) }
    power
  end

  def calculation_stat; end

  def table; end
end
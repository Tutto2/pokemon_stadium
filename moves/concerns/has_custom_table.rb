require_relative "../move"

module HasCustomTable
  def power
    table.each do |(range, power)|
      return power if range.include?(calculation_stat)
    end
  end

  def calculation_stat; end

  def table; end
end
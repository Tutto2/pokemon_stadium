require_relative "../../move"

module MultiStrikeAtk
  def strikes_count
    return hits unless hits == :random

    case rand(0..100)
    when 0..34 then 2
    when 35..69 then 3
    when 70..84 then 4
    else 5
    end
  end

  private
  def hits
    :random
  end
end
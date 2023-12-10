class BackstagePassesQualityChangeCalculator
  def initialize(change_multiple:)
    @change_multiple = change_multiple
  end

  def calculate(item)
    return 0 if item.sell_in <= 0

    proposed_quality = nil

    proposed_quality = case
                       when item.sell_in <= 5
                         item.quality + (3 * @change_multiple)
                       when item.sell_in <= 10
                         item.quality + (2 * @change_multiple)
                       else
                        item.quality + (1 * @change_multiple)
                       end

    if proposed_quality > 50
      return 50
    end

    return proposed_quality
  end
end

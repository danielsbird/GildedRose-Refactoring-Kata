class QualityChangeCalculator
  def initialize(change_amount:, change_limit: )
    @change_amount = change_amount
    @change_limit = change_limit
  end

  def calculate(item)
    change_amount = @change_amount

    if item.sell_in <= 0
      change_amount *= 2
    end

    exceeds_change_limit = if @change_amount < 0
      change_amount + item.quality < @change_limit
    else
      change_amount + item.quality > @change_limit
    end


    return @change_limit if exceeds_change_limit

    item.quality + change_amount
  end
end

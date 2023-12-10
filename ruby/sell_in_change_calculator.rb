class SellInChangeCalculator
  def initialize(change_amount:)
    @change_amount = change_amount
  end

  def calculate(item)
    item.sell_in + @change_amount
  end
end

require_relative './updating_item'
require_relative './quality_change_calculator'
require_relative './sell_in_change_calculator'

module ConjuredAgedBrieFactory
  QUALITY_CHANGE_AMOUNT = 2
  QUALITY_CHANGE_LIMIT = 50
  SELL_IN_CHANGE_AMOUNT = -1

  def self.build(item:)
    UpdatingItem.new(
      item: item,
      quality_change_calculator: QualityChangeCalculator.new(
        change_amount: QUALITY_CHANGE_AMOUNT,
        change_limit: QUALITY_CHANGE_LIMIT
      ),
      sell_in_change_calculator: SellInChangeCalculator.new(
        change_amount: SELL_IN_CHANGE_AMOUNT
      )
    )
  end
end

require_relative './updating_item'
require_relative './backstage_passes_quality_change_calculator'
require_relative './sell_in_change_calculator'

module BackstagePassesFactory
  SELL_IN_CHANGE_AMOUNT = 1

  def self.build(item:)
    UpdatingItem.new(
      item: item,
      quality_change_calculator: BackstagePassesQualityChangeCalculator.new(
        change_multiple: 1
      ),
      sell_in_change_calculator: SellInChangeCalculator.new(
        change_amount: SELL_IN_CHANGE_AMOUNT
      )
    )
  end
end

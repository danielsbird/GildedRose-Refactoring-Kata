require_relative './updating_item'
require_relative './backstage_passes_quality_change_calculator'
require_relative './sell_in_change_calculator'

module ConjuredBackstagePassesFactory
  CHANGE_MULTIPLE = 2
  SELL_IN_CHANGE_AMOUNT = 1

  def self.build(item:)
    UpdatingItem.new(
      item: item,
      quality_change_calculator: BackstagePassesQualityChangeCalculator.new(
        change_multiple: CHANGE_MULTIPLE
      ),
      sell_in_change_calculator: SellInChangeCalculator.new(
        change_amount: SELL_IN_CHANGE_AMOUNT
      )
    )
  end
end

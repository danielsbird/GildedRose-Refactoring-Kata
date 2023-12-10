require_relative './sell_in_change_calculator'
require_relative "./gilded_rose"

RSpec.describe SellInChangeCalculator do
  describe "#calculate" do
    it "returns the item's new sell_in value" do
      quality = 10
      sell_in = 5
      item = Item.new("foo", sell_in, quality)
      calculator = SellInChangeCalculator.new(change_amount: -1)

      result = calculator.calculate(item)

      expect(result).to equal(4)
    end
  end
end

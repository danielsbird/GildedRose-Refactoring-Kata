require_relative "./updating_item"
require_relative "./gilded_rose"

describe UpdatingItem do
  describe "#initialize" do
    context "when item quality is incorrectly negative" do
      it "raises an exception" do
        item = Item.new("foo", 10, -1)

        expect do
          UpdatingItem.new(
            item: item,
            quality_change_calculator: SimpleQualityChangeCalculator.new,
            sell_in_change_calculator: SimpleSellInChangeCalculator.new
          )
        end.to raise_error(ArgumentError, "Item quality cannot be negative")
      end
    end
  end

  describe "#name" do
    it "returns the name" do
      item = UpdatingItem.new(
        item: Item.new("foo", 10, 5),
        quality_change_calculator: SimpleQualityChangeCalculator.new,
        sell_in_change_calculator: SimpleSellInChangeCalculator.new
      )

      expect(item.name).to eq("foo")
    end
  end

  describe "#update" do
    it "updates the item quality" do
      item = UpdatingItem.new(
        item: Item.new("foo", 10, 5),
        quality_change_calculator: SimpleQualityChangeCalculator.new,
        sell_in_change_calculator: SimpleSellInChangeCalculator.new
      )

      item.update

      expect(item.quality).to eq(4)
    end

    it "updates the item sell_in" do
      item = UpdatingItem.new(
        item: Item.new("foo", 10, 5),
        quality_change_calculator: SimpleQualityChangeCalculator.new,
        sell_in_change_calculator: SimpleSellInChangeCalculator.new
      )

      item.update

      expect(item.sell_in).to eq(9)
    end
  end

  class SimpleQualityChangeCalculator
    def calculate(item)
      item.quality - 1
    end
  end

  class SimpleSellInChangeCalculator
    def calculate(item)
      item.sell_in - 1
    end
  end
end

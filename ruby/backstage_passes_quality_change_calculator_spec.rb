require_relative "./backstage_passes_quality_change_calculator"
require_relative "./gilded_rose"

RSpec.describe BackstagePassesQualityChangeCalculator do
  describe "#calculate" do
    context "when not conjured" do
      context "when the sell_in date is > 10" do
        context "when quality is less than 50" do
          it "increases quality by 1" do
            sell_in = 11
            quality = 49
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not increase quality" do
            sell_in = 11
            quality = 50
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end
  
      context "when the sell_in date is less than or equal to 10 but greater than 5" do
        context "when quality is <= 48" do
          it "increases quality by 2" do
            sell_in = 10
            quality = 48
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 49" do
          it "increases quality by 1" do
            sell_in = 10
            quality = 49
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not change quality" do
            sell_in = 10
            quality = 50
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end

      context "when the sell_in date is less than or equal to 5 but greater than 0" do
        context "when quality is <= 47" do
          it "increases quality by 3" do
            sell_in = 5
            quality = 47
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is greater than or equal to 47 but less than 50" do
          it "changes quality to 50" do
            sell_in = 5
            quality = 48
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not change quality" do
            sell_in = 5
            quality = 50
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end

      context "when the sell_in date is 0" do
        it "changes quality to 0" do
          sell_in = 0
          quality = 10
          item = Item.new("Backstage passes", sell_in, quality)
          calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

          result = calculator.calculate(item)

          expect(result).to equal(0)
        end
      end

      context "when the sell_in date is less than 0" do
        it "does not change quality from 0" do
          sell_in = -1
          quality = 0
          item = Item.new("Backstage passes", sell_in, quality)
          calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 1)

          result = calculator.calculate(item)

          expect(result).to equal(0)
        end
      end
    end

    context "when conjured" do
      context "when the sell_in date is > 10" do
        context "when quality is <= 48" do
          it "increases quality by 2" do
            sell_in = 11
            quality = 48
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 49" do
          it "increases quality by 1" do
            sell_in = 11
            quality = 49
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not increase quality" do
            sell_in = 11
            quality = 50
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end
  
      context "when the sell_in date is less than or equal to 10 but greater than 5" do
        context "when quality is <= 46" do
          it "increases quality by 4" do
            sell_in = 10
            quality = 45
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(49)
          end
        end

        context "when quality is greater than or equal to 47 but less than 50" do
          it "increases quality to 50" do
            sell_in = 10
            quality = 47
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not change quality" do
            sell_in = 10
            quality = 50
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end

      context "when the sell_in date is less than or equal to 5 but greater than 0" do
        context "when quality is <= 44" do
          it "increases quality by 6" do
            sell_in = 5
            quality = 43
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(49)
          end
        end

        context "when quality is greater than or equal to 45 but less than 50" do
          it "changes quality to 50" do
            sell_in = 5
            quality = 45
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not change quality" do
            sell_in = 5
            quality = 50
            item = Item.new("Backstage passes", sell_in, quality)
            calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end

      context "when the sell_in date is 0" do
        it "changes quality to 0" do
          sell_in = 0
          quality = 10
          item = Item.new("Backstage passes", sell_in, quality)
          calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

          result = calculator.calculate(item)

          expect(result).to equal(0)
        end
      end

      context "when the sell_in date is less than 0" do
        it "does not change quality from 0" do
          sell_in = -1
          quality = 0
          item = Item.new("Backstage passes", sell_in, quality)
          calculator = BackstagePassesQualityChangeCalculator.new(change_multiple: 2)

          result = calculator.calculate(item)

          expect(result).to equal(0)
        end
      end
    end
  end
end

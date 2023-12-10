require_relative "./quality_change_calculator"
require_relative "./gilded_rose"

RSpec.describe QualityChangeCalculator do
  describe "#calculate" do
    context "items without special rules" do
      context "when sell_in has not passed" do
        context "when quality is >= 1" do
          it "decreases quality by 1" do
            sell_in = 1
            quality = 10
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -1, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(9)
          end
        end

        context "when quality is 0" do
          it "does not decrease quality" do
            sell_in = 1
            quality = 0
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -1, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end
      end

      context "when sell_in date has passed" do
        context "when quality is >= 2" do
          it "decreases quality by 2" do
            sell_in = 0
            quality = 10
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -1, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(8)
          end
        end

        context "when quality is 1" do
          it "decreases quality to 0" do
            sell_in = 0
            quality = 1
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -1, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end

        context "when quality is 0" do
          it "does not decrease quality" do
            sell_in = 0
            quality = 0
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -1, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end
      end
    end

    context "for Aged Brie" do
      context "when sell_in has not passed" do
        context "when quality is < 50" do
          it "increases quality by 1" do
            sell_in = 1
            quality = 10
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 1, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(11)
          end
        end

        context "when quality is 50" do
          it "does not increase quality" do
            sell_in = 1
            quality = 50
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 1, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end

      context "when sell_in has passed" do
        context "when quality <= 48" do
          it "increases quality by 2" do
            sell_in = 0
            quality = 10
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 1, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(12)
          end
        end

        context "when quality is 49" do
          it "increases quality to 50" do
            sell_in = 0
            quality = 49
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 1, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not increase quality" do
            sell_in = 0
            quality = 50
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 1, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end
    end

    context "for conjured but otherwise normal items" do
      context "when sell_in has not passed" do
        context "when quality >= 2" do
          it "decreases quality by 2" do
            sell_in = 1
            quality = 10
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -2, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(8)
          end
        end

        context "when quality is 1" do
          it "decreases quality to 0" do
            sell_in = 1
            quality = 1
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -2, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end

        context "when quality is 0" do
          it "does not change quality" do
            sell_in = 1
            quality = 0
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -2, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end
      end

      context "when sell_in has passed" do
        context "when quality is >= 4" do
          it "decreases quality by 4" do
            sell_in = 0
            quality = 10
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -2, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(6)
          end
        end

        context "when quality is less than or equal to 3 but greater than 0" do
          it "decreases quality to 0" do
            sell_in = 0
            quality = 3
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -2, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end

        context "when quality is 0" do
          it "does not change quality" do
            sell_in = 0
            quality = 0
            item = Item.new("foo", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: -2, change_limit: 0)

            result = calculator.calculate(item)

            expect(result).to equal(0)
          end
        end
      end
    end

    context "for conjured Aged Brie" do
      context "when sell_in has not passed" do
        context "when quality is <= 48" do
          it "increases quality by 2" do
            sell_in = 1
            quality = 48
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 2, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 49" do
          it "increases quality by 1" do
            sell_in = 1
            quality = 49
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 2, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not increase quality" do
            sell_in = 1
            quality = 50
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 2, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end

      context "when sell_in has passed" do
        context "when quality <= 46" do
          it "increases quality by 4" do
            sell_in = 0
            quality = 46
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 4, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is greater than or equal to 47 but less than 50" do
          it "increases quality to 50" do
            sell_in = 0
            quality = 47
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 4, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end

        context "when quality is 50" do
          it "does not increase quality" do
            sell_in = 0
            quality = 50
            item = Item.new("Aged Brie", sell_in, quality)
            calculator = QualityChangeCalculator.new(change_amount: 4, change_limit: 50)

            result = calculator.calculate(item)

            expect(result).to equal(50)
          end
        end
      end
    end
  end
end

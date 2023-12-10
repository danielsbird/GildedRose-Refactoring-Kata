require File.join(File.dirname(__FILE__), 'gilded_rose')
require_relative "./updating_item"
require_relative "./quality_change_calculator"
require_relative "./sell_in_change_calculator"
require_relative "./deteriorating_item_factory"
require_relative "./aged_brie_factory"
require_relative "./backstage_passes_factory"
require_relative "./conjured_deteriorating_item_factory"
require_relative "./conjured_aged_brie_factory"
require_relative "./conjured_backstage_passes_factory"

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [
        DeterioratingItemFactory.build(item: Item.new("foo", 0, 0))
      ]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    describe "changing quality" do
      context "for non-conjured items" do
        context "for items without special quality rules" do
          context "when the sell_in date has not yet passed" do
            context "when item quality is > 0" do
              it "decrements quality by 1" do
                sell_in = 10
                quality = 5
                items = [
                  DeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 4
              end
            end
  
            context "when item quality is 0" do
              it "does not change quality" do
                sell_in = 10
                quality = 0
                items = [
                  DeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end
          end
  
          context "when the sell-in date has passed" do
            context "when item quality is > 1" do
              it "decrements quality by 2" do
                sell_in = 0
                quality = 5
                items = [
                  DeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 3
              end
            end
  
            context "when item quality is 1" do
              it "decrements quality by 1 so as to not decrease quality less than 0" do
                sell_in = 0
                quality = 1
                items = [
                  DeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end
  
            context "when item quality is 0" do
              it "does not change quality so as to not decrease quality less than 0" do
                sell_in = 0
                quality = 0
                items = [
                  DeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end
          end
        end
  
        context "for 'Aged Brie'" do
          context "when item quality < 50" do
            context "when sell_in date is > 0" do
              it "increments quality by 1" do
                sell_in = 10
                quality = 5
                items = [
                  AgedBrieFactory.build(item: Item.new("Aged Brie", sell_in, quality))
                ]
    
                GildedRose.new(items).update_quality()
    
                expect(items[0].quality).to eq 6
              end
            end 
            
            # This scenario is not documented in GildedRoseRequirements.txt
            context "when sell_in date is <= 0" do
              it "increases quality by 2" do
                sell_in = 0
                quality = 5
                items = [
                  AgedBrieFactory.build(item: Item.new("Aged Brie", sell_in, quality))
                ]
    
                GildedRose.new(items).update_quality()
    
                expect(items[0].quality).to eq 7
              end
            end
          end
  
          context "when item quality == 50" do
            it "does not change quality" do
              sell_in = 10
              quality = 50
              items = [
                  AgedBrieFactory.build(item: Item.new("Aged Brie", sell_in, quality))
              ]
  
              GildedRose.new(items).update_quality()
  
              expect(items[0].quality).to eq 50
            end
          end
        end
  
        context "for 'Sulfuras" do
          it "does not change quality" do
            sell_in = 100
            quality = 80
            items = [
              UpdatingItem.new(
                item: Item.new("Sulfuras, Hand of Ragnaros", sell_in, quality),
                quality_change_calculator: QualityChangeCalculator.new(
                  change_amount: 0,
                  change_limit: Float::INFINITY
                ),
                sell_in_change_calculator: SellInChangeCalculator.new(
                  change_amount: 0
                )
              )
            ]
  
            GildedRose.new(items).update_quality()
  
            expect(items[0].quality).to eq 80
          end
        end
  
        context "for 'Backstage passes'" do
          context "when item quality < 50" do
            context "when there are > 10 days until the concert" do
              it "increments quality by 1" do
                sell_in = 11
                quality = 5
                items = [
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)
                  )
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 6
              end
            end
    
            context "when there are <= 10 days and >= 5 days until the concert" do
              it "increments quality by 2" do
                items = [
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 5)
                  ),
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 9, 5),
                  ),
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 5)
                  )
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 7
                expect(items[1].quality).to eq 7
                expect(items[2].quality).to eq 7
              end
            end
    
            context "when there are <= 5 days and >= 0 days until the concert" do
              it "increments quality by 3" do
                items = [
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)
                  ),
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 5)
                  ),
                  BackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 5)
                  )
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 8
                expect(items[1].quality).to eq 8
                expect(items[2].quality).to eq 8
              end
            end
          end
  
          context "when item quality is 50" do
            it "does not change quality" do
              sell_in = 10
              quality = 50
              items = [
                BackstagePassesFactory.build(
                  item: Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)
                )
              ]
  
              GildedRose.new(items).update_quality()
  
              expect(items[0].quality).to eq 50
            end
          end
  
          context "after the concert" do
            it "decreases quality to 0" do
              sell_in = 0
              quality = 5
              items = [
                BackstagePassesFactory.build(
                  item: Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)
                )
              ]
  
              GildedRose.new(items).update_quality()
  
              expect(items[0].quality).to eq 0
            end
          end
        end
      end

      context "for conjured items" do
        context "for items without special quality rules" do
          context "when the sell_in date has not yet passed" do
            context "when item quality is > 1" do
              it "decrements quality by 2" do
                sell_in = 10
                quality = 5
                items = [
                  ConjuredDeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 3
              end
            end
  
            context "when item quality is 1" do
              it "decreases quality to 0" do
                sell_in = 10
                quality = 1
                items = [
                  ConjuredDeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end

            context "when item quality is 0" do
              it "does not change quality" do
                sell_in = 10
                quality = 0
                items = [
                  ConjuredDeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end
          end
  
          context "when the sell-in date has passed" do
            context "when item quality is > 3" do
              it "decrements quality by 4" do
                sell_in = 0
                quality = 5
                items = [
                  ConjuredDeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 1
              end
            end
  
            context "when item quality is less than or equal to 3 but greater than 0" do
              it "decreases quality to 0" do
                sell_in = 0
                quality = 2
                items = [
                  ConjuredDeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end
  
            context "when item quality is 0" do
              it "does not change quality" do
                sell_in = 0
                quality = 0
                items = [
                  ConjuredDeterioratingItemFactory.build(item: Item.new("foo", sell_in, quality))
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 0
              end
            end
          end
        end
  
        context "for 'Aged Brie'" do
          context "when item quality < 49" do
            context "when sell_in date is > 0" do
              it "increases quality by 2" do
                sell_in = 10
                quality = 5
                items = [
                  ConjuredAgedBrieFactory.build(item: Item.new("Aged Brie", sell_in, quality))
                ]
    
                GildedRose.new(items).update_quality()
    
                expect(items[0].quality).to eq 7
              end
            end 
            
            # This scenario is not documented in GildedRoseRequirements.txt
            context "when sell_in date is <= 0" do
              it "increases quality by 4" do
                sell_in = 0
                quality = 5
                items = [
                  ConjuredAgedBrieFactory.build(item: Item.new("Aged Brie", sell_in, quality))
                ]
    
                GildedRose.new(items).update_quality()
    
                expect(items[0].quality).to eq 9
              end
            end
          end
  
          context "when item quality == 50" do
            it "does not change quality" do
              sell_in = 10
              quality = 50
              items = [
                ConjuredAgedBrieFactory.build(item: Item.new("Aged Brie", sell_in, quality))
              ]
  
              GildedRose.new(items).update_quality()
  
              expect(items[0].quality).to eq 50
            end
          end
        end
  
        context "for 'Sulfuras" do
          # The tests for conjured Sulfuras are intentionally not any different from the tests for
          # non-conjured Sulfuras because conjuring Sulfuras doesn't change its behaviour.
          it "does not change quality" do
            sell_in = 100
            quality = 80
            items = [
              UpdatingItem.new(
                item: Item.new("Sulfuras, Hand of Ragnaros", sell_in, quality),
                quality_change_calculator: QualityChangeCalculator.new(
                  change_amount: 0,
                  change_limit: Float::INFINITY
                ),
                sell_in_change_calculator: SellInChangeCalculator.new(
                  change_amount: 0
                )
              )
            ]
  
            GildedRose.new(items).update_quality()
  
            expect(items[0].quality).to eq 80
          end
        end
  
        context "for 'Backstage passes'" do
          context "when item quality < 49" do
            context "when there are > 10 days until the concert" do
              it "increments quality by 2" do
                sell_in = 11
                quality = 5
                items = [
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)
                  )
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 7
              end
            end
    
            context "when there are <= 10 days and >= 5 days until the concert" do
              it "increments quality by 4" do
                items = [
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 5)
                  ),
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 9, 5),
                  ),
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 5)
                  )
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 9
                expect(items[1].quality).to eq 9
                expect(items[2].quality).to eq 9
              end
            end
    
            context "when there are <= 5 days and >= 0 days until the concert" do
              it "increments quality by 6" do
                items = [
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)
                  ),
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 5)
                  ),
                  ConjuredBackstagePassesFactory.build(
                    item: Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 5)
                  )
                ]
  
                GildedRose.new(items).update_quality()
  
                expect(items[0].quality).to eq 11
                expect(items[1].quality).to eq 11
                expect(items[2].quality).to eq 11
              end
            end
          end
  
          context "when item quality is 50" do
            it "does not change quality" do
              sell_in = 10
              quality = 50
              items = [
                ConjuredBackstagePassesFactory.build(
                  item: Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)
                )
              ]
  
              GildedRose.new(items).update_quality()
  
              expect(items[0].quality).to eq 50
            end
          end
  
          context "after the concert" do
            it "decreases quality to 0" do
              sell_in = 0
              quality = 5
              items = [
                ConjuredBackstagePassesFactory.build(
                  item: Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)
                )
              ]
  
              GildedRose.new(items).update_quality()
  
              expect(items[0].quality).to eq 0
            end
          end
        end
      end
    end

    describe "changing sell_in" do
      context "for items without special sell_in rules" do
        it "decrements sell_in by 1" do
          sell_in = 10
          quality = 5
          items = [
            UpdatingItem.new(
              item: Item.new("foo", sell_in, quality),
              quality_change_calculator: QualityChangeCalculator.new(
                change_amount: -1,
                change_limit: 0
              ),
              sell_in_change_calculator: SellInChangeCalculator.new(
                change_amount: -1
              )
            )
          ]

          GildedRose.new(items).update_quality()

          expect(items[0].sell_in).to eq 9
        end
      end

      context "for 'Sulfuras'" do
        it "does not change sell_in" do
          # I arbitrarily chose 100 for the sell_in value for Sulfuras
          sell_in = 100
          quality = 80
          items = [
            UpdatingItem.new(
              item: Item.new("Sulfuras, Hand of Ragnaros", sell_in, quality),
              quality_change_calculator: QualityChangeCalculator.new(
                change_amount: 0,
                change_limit: Float::INFINITY
              ),
              sell_in_change_calculator: SellInChangeCalculator.new(
                change_amount: 0
              )
            )
          ]

          GildedRose.new(items).update_quality()

          expect(items[0].sell_in).to eq 100
        end
      end
    end
  end
end

class UpdatingItem
  def initialize(item:, quality_change_calculator:, sell_in_change_calculator:)
    raise ArgumentError.new("Item quality cannot be negative") if item.quality < 0

    @item = item
    @quality_change_calculator = quality_change_calculator
    @sell_in_change_calculator = sell_in_change_calculator
  end
  
  def name
    @item.name
  end

  def quality
    @item.quality
  end

  def sell_in
    @item.sell_in
  end

  def update
    update_quality
    update_sell_in
  end

  def update_quality
    @item.quality = @quality_change_calculator.calculate(@item)
  end

  def update_sell_in
    @item.sell_in = @sell_in_change_calculator.calculate(@item)
  end
end

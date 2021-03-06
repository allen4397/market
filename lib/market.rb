class Market
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.check_stock(item) != 0
    end
  end

  def sorted_item_list
    items = []
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        items << item unless items.include?(item)
      end
    end
    items.sort
  end

  def total_inventory
    inventory = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        inventory[item] += quantity
      end
    end
    return inventory
  end

  def sell(item, quantity)
    if enough?(item, quantity)
      remove_items(item, quantity)
      true
    else
      false
    end
  end

  def enough?(item, quantity)
    total_inventory[item] > quantity
  end

  def remove_items(item, quantity)
    vendors_that_sell(item).each do |vendor|
      quantity = how_much_more_needed(item, vendor, quantity)
      break if quantity == 0
      vendor.sell_out(item)
    end
  end

  def how_much_more_needed(item, vendor, amount_needed)
    if vendor.check_stock(item) >= amount_needed
      vendor.remove_items(item, amount_needed)
      return 0
    else
      amount_needed -= vendor.check_stock(item)
    end
  end
end

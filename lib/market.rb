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
    enough?(item, quantity)
  end

  def enough?(item, quantity)
    total_inventory[item] > quantity
  end
end

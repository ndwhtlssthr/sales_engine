class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :repository

  def initialize(data, parent)
    @id          = data[:id].to_i
    @name        = data[:name]
    @description = data[:description]
    @unit_price  = BigDecimal.new(data[:unit_price])
    @merchant_id = data[:merchant_id].to_i
    @created_at  = Date.parse(data[:created_at])
    @updated_at  = Date.parse(data[:updated_at])
    @repository  = parent
  end

  def invoice_items
    repository.find_invoice_items_from(id)
  end

  def merchant
    repository.find_merchant_from(merchant_id)
  end

  def total_revenue
    repository.find_item_revenue(id)
  end

  def number_sold
    repository.find_items_sold(id)
  end

  def best_day
    repository.find_best_day(id)
  end
end

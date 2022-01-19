class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted
    invoice_items
      .joins(item: [merchant: :bulk_discounts])
      .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
      .select('invoice_items.*, MAX(percent_discount) AS discount')
      .group(:id)
  end

  def bd_total_revenue
    revenue = 0

    discounted.each do |invoice_item|
      full_price = invoice_item.quantity * invoice_item.unit_price
      revenue += (1 - invoice_item.discount) * full_price
    end
    revenue
  end

end

# #write test
# def filter_doubles
#   ii_unique = Hash.new(0)
#
#   discount_amount.each do |ii|
#     if !ii_unique.keys.find {|k| k == discount[0]}
#       ii_unique[ii] = ii.discount
#     end
#   end
#   ii_unique
# end

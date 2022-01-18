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

  def discount_amount
    discount = invoice_items
      .joins(item: [merchant: :bulk_discounts])
      .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
      .select("bulk_discounts.*, bulk_discounts.percent_discount AS discount")
      .order(discount: :desc)
      .first
      .discount
  end



  def bd_total_revenue
    total_revenue * (1 - discount_amount)
  end
end

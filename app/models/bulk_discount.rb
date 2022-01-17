class BulkDiscount < ApplicationRecord
  validates_numericality_of :percent_discount,
                            :quantity_threshold

  belongs_to :merchant
end

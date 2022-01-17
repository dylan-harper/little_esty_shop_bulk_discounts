require 'rails_helper'

RSpec.describe BulkDiscount do

  it { should belong_to :merchant }
  it { should validate_numericality_of :percent_discount }
  it { should validate_numericality_of :quantity_threshold }

end

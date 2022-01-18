require 'rails_helper'

RSpec.describe 'the bulk discount edit page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')

    @discount_1 = @merchant1.bulk_discounts.create!(percent_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant1.bulk_discounts.create!(percent_discount: 0.30, quantity_threshold: 15)
    @discount_3 = @merchant1.bulk_discounts.create!(percent_discount: 0.35, quantity_threshold: 20)
    @discount_4 = @merchant1.bulk_discounts.create!(percent_discount: 0.40, quantity_threshold: 25)

    visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@discount_1.id}/edit"
  end

  it 'autopopulates current values' do
    #Works but not picking up on the autofilled values
    expect(page).to have_content("Percent discount")
    expect(page).to have_content("Quantity threshold")
    expect(page).to have_content(@discount_1.percent_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
  end
end

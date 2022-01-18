require 'rails_helper'

RSpec.describe 'the bulk discount show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')

    @discount_1 = @merchant1.bulk_discounts.create!(percent_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant1.bulk_discounts.create!(percent_discount: 0.30, quantity_threshold: 15)
    @discount_3 = @merchant1.bulk_discounts.create!(percent_discount: 0.35, quantity_threshold: 20)
    @discount_4 = @merchant1.bulk_discounts.create!(percent_discount: 0.40, quantity_threshold: 25)

    visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@discount_1.id}"
  end

  it 'displays bulk discount information' do
    expect(page).to have_content(@discount_1.percent_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
  end

  it 'has a link to edit the bulk discount' do
    expect(page).to have_link("Edit Bulk Discount")

    click_link "Edit Bulk Discount"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount_1.id}/edit")
  end
end

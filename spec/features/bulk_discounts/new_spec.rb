require 'rails_helper'

RSpec.describe 'bulk discount new page' do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')
  end

  it 'should be able to fill in a form and create a new bulk discount' do
    visit new_merchant_bulk_discount_path(@m1)

    fill_in :percent_discount, with: 0.55
    fill_in :quantity_threshold, with: 30

    click_button

    expect(current_path).to eq(merchant_bulk_discounts_path(@m1))

    within("#bulk-discounts") do
      expect(page).to have_content(0.55)
      expect(page).to have_content(30)
    end
  end
end

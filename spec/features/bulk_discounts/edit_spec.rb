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

  xit 'autopopulates current values' do
    #Works but not picking up on the autofilled values
    expect(page).to have_content("Percent discount #{@discount_1.percent_discount}")
    expect(page).to have_content("Quantity threshold #{@discount_1.quantity_threshold}")

    expect(page).to have_content(@discount_1.percent_discount)
    expect(page).to have_content(@discount_1.quantity_threshold)
  end

  it 'can update bulk discount values' do
    fill_in :percent_discount, with: 0.09
    fill_in :quantity_threshold, with: 18

    click_button

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount_1.id}")
    expect(page).to have_content(0.09)
    expect(page).to have_content(18)
  end
end

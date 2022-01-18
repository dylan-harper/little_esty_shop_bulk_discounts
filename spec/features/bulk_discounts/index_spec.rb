require 'rails_helper'

RSpec.describe 'merchant bulk discount index page' do

  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @discount_1 = @merchant1.bulk_discounts.create!(percent_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant1.bulk_discounts.create!(percent_discount: 0.30, quantity_threshold: 15)
    @discount_3 = @merchant1.bulk_discounts.create!(percent_discount: 0.35, quantity_threshold: 20)
    @discount_4 = @merchant1.bulk_discounts.create!(percent_discount: 0.40, quantity_threshold: 25)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it 'shows the merchant name' do
    expect(page).to have_content(@merchant1.name)
  end

  it 'displays information for the merchants bulk discounts' do
    within("#bulk-discounts") do
      expect(page).to have_content(@discount_1.percent_discount).and(have_content(@discount_1.quantity_threshold))
      expect(page).to have_content(@discount_2.percent_discount).and(have_content(@discount_1.quantity_threshold))
      expect(page).to have_content(@discount_3.percent_discount).and(have_content(@discount_1.quantity_threshold))
      expect(page).to have_content(@discount_4.percent_discount).and(have_content(@discount_1.quantity_threshold))
    end
  end

  it 'has a link to each bulk discount show page' do
    click_link "Bulk Discount ##{@discount_1.id}"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@discount_1.id}")
  end

  it 'has a section with 3 upcoming US holidays' do
    within("#upcoming-holidays") do
      expect(page).to_not have_content("Martin Luther King, Jr. Day, 2022-01-17")
      expect(page).to have_content("Washington's Birthday, 2022-02-21")
      expect(page).to have_content("Good Friday, 2022-04-15")
      expect(page).to have_content("Memorial Day, 2022-05-30")
    end
  end

  it 'has a link to create a new bulk discount' do
    expect(page).to have_content("Create Bulk Discount")

    click_link "Create Bulk Discount"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
  end

  it 'has a link to delete a bulk discount' do
    within("#bulk-discounts") do
      expect(page).to have_link("Delete ##{@discount_1.id}")
      expect(page).to have_link("Delete ##{@discount_2.id}")
      expect(page).to have_link("Delete ##{@discount_3.id}")
      expect(page).to have_link("Delete ##{@discount_4.id}")
    end

    click_link("Delete ##{@discount_1.id}")

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")

    within("#bulk-discounts") do
      expect(page).to_not have_link("Delete ##{@discount_1.id}")
      expect(page).to have_link("Delete ##{@discount_2.id}")
      expect(page).to have_link("Delete ##{@discount_3.id}")
      expect(page).to have_link("Delete ##{@discount_4.id}")
    end
  end

end

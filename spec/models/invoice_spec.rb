require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Bare Bear')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Jeff', last_name: 'Jones')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_4 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 4, unit_price: 10, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_8.id, quantity: 4, unit_price: 10, status: 1)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_8.id, quantity: 4, unit_price: 10, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 2, unit_price: 10, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_8.id, quantity: 2, unit_price: 10, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_8.id, quantity: 2, unit_price: 10, status: 1)

      @discount_1 = @merchant1.bulk_discounts.create!(percent_discount: 0.20, quantity_threshold: 4)
      @discount_2 = @merchant1.bulk_discounts.create!(percent_discount: 0.30, quantity_threshold: 8)
      @discount_3 = @merchant1.bulk_discounts.create!(percent_discount: 0.35, quantity_threshold: 20)
      @discount_4 = @merchant1.bulk_discounts.create!(percent_discount: 0.40, quantity_threshold: 25)

      @discount_5 = @merchant2.bulk_discounts.create!(percent_discount: 0.20, quantity_threshold: 1)
      @discount_6 = @merchant2.bulk_discounts.create!(percent_discount: 0.30, quantity_threshold: 1)
      @discount_7 = @merchant2.bulk_discounts.create!(percent_discount: 0.35, quantity_threshold: 1)
      @discount_8 = @merchant2.bulk_discounts.create!(percent_discount: 0.40, quantity_threshold: 1)
    end

    it "discount_amount" do
      expect(@invoice_1.discounted).to eq([@ii_1, @ii_2])
    end

    it "bd_total_revenue" do
      expect(@invoice_1.bd_total_revenue).to eq(95)
    end
  end
end

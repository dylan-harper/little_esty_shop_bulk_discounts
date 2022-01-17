class BulkDiscountsController < ApplicationController

  def index
    @facade = HolidayFacade.new
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    
  end

end

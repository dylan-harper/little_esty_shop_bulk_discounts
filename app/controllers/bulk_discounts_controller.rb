class BulkDiscountsController < ApplicationController

  def index
    @facade = HolidayFacade.new
    @bulk_discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    #change the below to bulk discount?
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    #do I need this
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])

    @merchant.bulk_discounts.create!(
                         percent_discount: bd_params[:percent_discount],
                         quantity_threshold: bd_params[:quantity_threshold]
                         )

    redirect_to action: :index
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy

    redirect_to action: :index
  end

  private

  def bd_params
    params.permit(:percent_discount,
                  :quantity_threshold,
                  :merchant_id)
  end

end

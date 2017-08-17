class Api::V1::MerchantsController < ApplicationController

  def index
    render json: Merchant.all
  end

  def show
    check_path
    render json: @merchant
  end

  private

  def check_path
    if request.url == api_v1_invoice_my_merchant_url(validate_inv)
      @merchant = validate_inv.merchant
    elsif request.url == api_v1_item_my_merchant_url(validate_item)
      @merchant = validate_item.merchant
    else
      @merchant = Merchant.find(params[:id])
    end
  end

  def validate_inv
    if params[:invoice_id].nil?
      0
    else
      Invoice.find(params[:invoice_id])
    end
  end

  def validate_item
    if params[:item_id].nil?
      0
    else
      Item.find(params[:item_id])
    end
  end
end

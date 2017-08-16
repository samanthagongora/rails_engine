class Api::V1::ItemsController < ApplicationController
  def index
    check_path
    render json: @items
  end

  def show
    render json: Item.find(params[:id])
  end

  private

  def check_path
    if request.url == api_v1_merchant_items_url(validate_merch)
      @items = validate_merch.items
    elsif request.url == api_v1_invoice_my_items_url(validate_inv)
      @items = validate_inv.items
    else
      @items = Item.all
    end
  end

  def validate_merch
    if params[:merchant_id].nil?
      0
    else
      Merchant.find(params[:merchant_id]) unless params[:merchant_id].nil?
    end
  end

  def validate_inv
    if params[:invoice_id].nil?
      0
    else
      Invoice.find(params[:invoice_id]) unless params[:invoice_id].nil?
    end
  end
end

class Api::V1::InvoiceItemsController < ApplicationController
  def index
    check_path
    render json: @invoice_items
  end

  def show
    render json: InvoiceItem.find(params[:id])
  end

  private

  def check_path
    if request.url == api_v1_invoice_my_invoiceitems_url(validate_inv)
      @invoice_items = validate_inv.invoice_items
    elsif request.url == api_v1_item_my_invoiceitems_url(validate_item)
      @invoice_items = validate_item.invoice_items
    else
      @invoice_items = InvoiceItem.all
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

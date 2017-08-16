class Api::V1::InvoicesController < ApplicationController
  def index
    render json: Invoice.all
  end

  def show
    check_path
    render json: @invoice
  end

  private

  def check_path
    if request.url == api_v1_invoice_item_my_invoice_url(validate_inv_items)
      @invoice = validate_inv_items.invoice
    else
      @invoice = Invoice.find(params[:id])
    end
  end

  def validate_inv_items
    if params[:invoice_item_id].nil?
      0
    else
      InvoiceItem.find(params[:invoice_item_id])
    end
  end
end

class Api::V1::InvoiceItems::FindController < ApplicationController
  def show
    render json: InvoiceItem.find_by(invoice_items_params)
  end

  def index
    render json: InvoiceItem.where(invoice_items_params)
  end

  private

  def invoice_items_params
    params.permit(:id, :invoice_id, :item_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end

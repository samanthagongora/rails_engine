require 'bigdecimal'
require 'bigdecimal/util'

class Api::V1::InvoiceItems::FindController < ApplicationController
  def show
    render json: InvoiceItem.find_by(invoice_items_params)
  end

  def index
    render json: InvoiceItem.where(invoice_items_params)
  end

  private

  def invoice_items_params
    unless params[:unit_price].nil?
      params[:unit_price] = (params[:unit_price].to_f * 100).round(2).to_s
    end
    params.permit(:id, :invoice_id, :item_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end

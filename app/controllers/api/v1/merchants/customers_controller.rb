class Api::V1::Merchants::CustomersController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    render json: Customer.joins(:invoices).where(invoices: {status: "pending", merchant_id: merchant.id})
  end
end

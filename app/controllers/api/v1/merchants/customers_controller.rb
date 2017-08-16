class Api::V1::Merchants::CustomersController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    binding.pry
    Invoice.joins(:transactions).where(merchant_id: merchant.id, transactions: {result: 'success'}).group(:customer_id).count.order
  end
end

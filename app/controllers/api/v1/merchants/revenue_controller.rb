class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    binding.pry
    render json: Merchant.most_revenue(params[:quantity])
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: merchant.revenue_by_date(params[:date])
  end
end

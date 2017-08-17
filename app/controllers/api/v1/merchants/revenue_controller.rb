class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: {revenue: Merchant.most_revenue(params[:quantity])}
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    render json: {revenue: merchant.revenue_by_date(params[:date])}
    # render json: {:revenue => merchant.revenue(params[:date])}
  end
end

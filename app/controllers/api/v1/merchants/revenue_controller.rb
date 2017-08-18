class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: Merchant.most_revenue(params[:quantity])
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    render json: merchant.revenue_by_date(params[:date]), serializer: RevenueSerializer
  end
end

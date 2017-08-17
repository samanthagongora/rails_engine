class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    render json: merchant.revenue_by_date(params[:date])
  end
end

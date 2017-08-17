class Api::V1::Merchants::RevenueByDateController < ApplicationController

  def show
    render json: Merchant.all_revenue_by_date(params[:date])
  end
end

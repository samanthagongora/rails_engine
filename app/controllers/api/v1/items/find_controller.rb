class Api::V1::Items::FindController < ApplicationController
  def show
    render json: Item.find_by(item_params)
  end

  def index
    # binding.pry
    render json: Item.where(item_params)
  end

  private

  def item_params
    if params[:unit_price]
      params[:unit_price] = (params[:unit_price].to_f * 100).round(2).to_s
    elsif params[:updated_at]
      params[:updated_at] = params[:updated_at].to_datetime
    elsif params[:created_at]
      params[:created_at] = params[:created_at].to_datetime
    end
    params.permit(:id, :name, :merchant_id, :description, :unit_price, :created_at, :updated_at )
  end
end

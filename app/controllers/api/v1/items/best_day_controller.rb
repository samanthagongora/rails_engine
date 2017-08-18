class Api::V1::Items::BestDayController < ApplicationController

  def show
    item = Item.find(params[:item_id])
    render json:  {:best_day => item.best_day}
  end
end

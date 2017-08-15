class Api::V1::InvoicesController < ApplicationController
  def index
    render json: Invoice.all
  end

  def show
    render json: Invoice.find(params[:id])
  end

  def create
    render json: Invoice.create(invoice_params)
  end

  def update
    render json: Invoice.update(params[:id], invoice_params)
  end

  def destroy
    Invoice.delete(params[:id])
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status, :customer_id, :merchant_id, :created_at, :updated_at)
  end
end

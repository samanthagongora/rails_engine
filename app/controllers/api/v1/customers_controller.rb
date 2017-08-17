class Api::V1::CustomersController < ApplicationController

  def index
    render json: Customer.all
  end

  def show
    check_path
    render json: @customer 
  end

  private

  def check_path
    if request.url == api_v1_invoice_my_customer_url(validate_inv)
      @customer = validate_inv.customer
    else
      @customer = Customer.find(params[:id])
    end
  end

  def validate_inv
    if params[:invoice_id].nil?
      0
    else
      Invoice.find(params[:invoice_id])
    end
  end
end

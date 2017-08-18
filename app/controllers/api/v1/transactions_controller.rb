class Api::V1::TransactionsController < ApplicationController

  def index
    check_path
    render json: @transactions
  end

  def show
    render json: Transaction.find(params[:id])
  end

  private

  def check_path
    if request.url == api_v1_invoice_my_transactions_url(validate_inv)
      @transactions = validate_inv.transactions
    else
      @transactions = Transaction.all
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

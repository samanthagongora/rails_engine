require 'rails_helper'
require 'date'

describe "Invoices API" do
  it "sends a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_success

    invoices = JSON.parse(response.body)

    expect(invoices.count).to eq 3
  end

  it "can get one invoice by its id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  it "can create a new invoice" do
    customer = create(:customer)
    merchant = create(:merchant)

    invoice_params = {status: 'shipped',
    customer_id: customer.id,
    merchant_id: merchant.id,
    created_at: DateTime.now,
    updated_at: DateTime.now}

    post "/api/v1/invoices", params:{ invoice: invoice_params }
    invoice = Invoice.last

    assert_response :success
    expect(response).to be_success

    expect(invoice.customer_id).to eq(customer.id)
  end

  it "can update an existing invoice" do
    id = create(:invoice).id
    new_customer = create(:customer)
    previous_name = Invoice.last.customer
    invoice_params = { customer_id: new_customer.id }

    put "/api/v1/invoices/#{id}", params: {invoice: invoice_params}
    invoice = Invoice.find_by(id: id)

    expect(response).to be_success
    expect(invoice.customer).to_not eq(previous_name)
    expect(invoice.customer.id).to eq(invoice_params[:customer_id])
  end

  it "can destroy an invoice" do
    invoice = create(:invoice)

    expect(Invoice.count).to eq(1)

    # this is another way:
    # expect{delete "/api/v1/invoices/#{invoice.id}"}.to change(invoice, :count).by(-1)

    delete "/api/v1/invoices/#{invoice.id}"

    expect(response).to be_success
    expect(Invoice.count).to eq(0)
    expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end

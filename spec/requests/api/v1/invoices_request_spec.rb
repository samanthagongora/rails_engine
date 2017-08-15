require 'rails_helper'

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

  it "can get one invoice by attribute" do
    customer = create(:customer)
    id = create(:invoice, customer: customer).id

    get "/api/v1/invoices/find?customer_id=#{customer.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  it "can get one invoice by another attribute" do
    merchant = create(:merchant)
    id = create(:invoice, merchant: merchant).id

    get "/api/v1/invoices/find?merchant_id=#{merchant.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  it "can get all invoices by attribute" do
    customer = create(:customer)
    create_list(:invoice, 4, customer: customer)

    get "/api/v1/invoices/find_all?customer_id=#{customer.id}"

    invoices = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices.count).to eq(4)
  end

  it "can get all invoices by another attribute" do
    create_list(:invoice, 4, status: 'shipped')

    get "/api/v1/invoices/find_all?status=shipped"

    invoices = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices.count).to eq(4)
  end

  it "can return one random record" do
    invoice1 = create(:invoice)
    invoice2 = create(:invoice)
    invoice3 = create(:invoice)

    invoices = [invoice1.id, invoice2.id, invoice3.id]

    get "/api/v1/invoices/random"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices).to include(invoice['id'])
  end
end

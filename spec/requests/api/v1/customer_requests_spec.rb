require 'rails_helper'

describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    customers = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(customers.count).to eq(3)
  end

  it "can get one customer by its id" do
    cust = create(:customer)

    get "/api/v1/customers/#{cust.id}"

    customer = JSON.parse(response.body)

    expect(response).to be_success
    expect(customer["id"]).to eq(cust.id)
    expect(customer["first_name"]).to eq(cust.first_name)
  end

  it "can find a customer by it's name" do
    create_list(:customer, 3)
    show_cust = Customer.first
    get "/api/v1/customers/find?name=#{show_cust.first_name}"

    customer = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(customer[:id]).to eq(show_cust.id)
    expect(customer[:first_name]).to eq(show_cust.first_name)
    expect(customer[:last_name]).to eq(show_cust.last_name)
  end

  it "can find all customer by shared name" do
    create_list(:customer, 3)
    show_cust = Customer.first
    get "/api/v1/customers/find_all?name=#{show_cust.first_name}"

    customers = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(customers.count).to eq(3)
  end

  it "can return a random customer" do
    c1 = create(:customer, first_name: "Joey")
    c2 = create(:customer, first_name: "Amy")
    c3 = create(:customer, first_name: "Tyler")

    get "/api/v1/customers/random"

    customer = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(customer.count).to eq(1)
    expect([c1.first_name, c2.first_name, c3.first_name]).to include(customer.first[:first_name])
  end

  it "can return all invoices for customer" do
    customer = create(:customer)
    invoices = create_list(:invoice, 5, customer: customer)

    get "/api/v1/customers/#{customer.id}/invoices"

    returned_invoices = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_invoices.count).to eq(5)
  end

  it "can return all transactions for customer" do
    customer = create(:customer)
    invoice = create(:invoice, customer: customer)
    transactions = create_list(:transaction, 4, invoice: invoice)

    get "/api/v1/customers/#{customer.id}/transactions"

    returned_transactions = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_transactions.count).to eq(4)
  end

  it "can return its favorite merchant" do
    customer = create(:customer)
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    invoice1 = create(:invoice, customer: customer, merchant: merchant1)
    invoice1.transactions << create(:transaction)
    invoice2 = create(:invoice, customer: customer, merchant: merchant1)
    invoice2.transactions << create(:transaction)
    invoice3 = create(:invoice, customer: customer, merchant: merchant2)
    invoice3.transactions << create(:transaction)

    get "/api/v1/customers/#{customer.id}/favorite_merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant[:id]).to eq(merchant1.id)
    expect(merchant[:name]).to eq(merchant1.name)
    expect(merchant[:id]).to_not eq(merchant2.id)
  end
end

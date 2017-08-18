require 'rails_helper'
require 'date'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(3)
  end

  it "can get one merchant by its id" do
    merch = create(:merchant)

    get "/api/v1/merchants/#{merch.id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant[:id]).to eq(merch.id)
    expect(merchant[:name]).to eq(merch.name)
  end

  it "can find a merchant by it's name" do
    create_list(:merchant, 3)
    show_merch = Merchant.first
    get "/api/v1/merchants/find?name=#{show_merch.name}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(merchant[:id]).to eq(show_merch.id)
    expect(merchant[:name]).to eq(show_merch.name)
  end

  it "can find all merchant by shared name" do
    create_list(:merchant, 3)
    show_merch = Merchant.first
    get "/api/v1/merchants/find_all?name=#{show_merch.name}"

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(3)
  end

  it "can return a random merchant" do
    m1 = create(:merchant, name: "Tests")
    m2 = create(:merchant, name: "for")
    m3 = create(:merchant, name: "Dayz")

    get "/api/v1/merchants/random"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(merchant.count).to eq(1)
    expect([m1.name, m2.name, m3.name]).to include(merchant.first[:name])
  end

  xit "can return all customers with pending invoices" do
    customers = create_list(:customer, 4)
    merchant = create(:merchant)
    invoice1 = create(:invoice, merchant: merchant, customer: customers[0], status: "pending")
    invoice2 = create(:invoice, merchant: merchant, customer: customers[1], status: "shipped")
    invoice3 = create(:invoice, merchant: merchant, customer: customers[2], status: "shipped")
    invoice4 = create(:invoice, merchant: merchant, customer: customers[3], status: "pending")

    get "/api/v1/merchants/#{merchant.id}/customers_with_pending_invoices"
    returned_customers = JSON.parse(response.body)

    expect(response).to be_success
    expect(returned_customers.count).to eq(2)
    expect(returned_customers).to include(customers[0].id)
    expect(returned_customers).to include(customers[3].id)
  end

  it "can return favorite customer" do
    merchant = create(:merchant)
    customer1 = create(:customer)
    customer2 = create(:customer)
    invoice1 = create(:invoice, customer: customer1, merchant: merchant)
    invoice2 = create(:invoice, customer: customer2, merchant: merchant)
    transactions1 = create_list(:transaction, 4, invoice: invoice1, result: "success")
    transactions2 = create_list(:transaction, 2, invoice: invoice2, result: "success")
    transactions3 = create_list(:transaction, 2, invoice: invoice2, result: "failed")

    get "/api/v1/merchants/#{merchant.id}/favorite_customer"
    customer = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(customer[:id]).to eq(customer1.id)
  end

  it "can return revenue for a date" do
    merchant = create(:merchant)
    invoice = create(:invoice, merchant: merchant, created_at: DateTime.now)
    invoice.transactions << create(:transaction)
    invoice_items = create_list(:invoice_item, 4, invoice: invoice, unit_price: 10000)

    get "/api/v1/merchants/#{merchant.id}/revenue?date=#{invoice.created_at}"
    returned_revenue = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_revenue[:revenue]).to eq('400.0')
  end

  it "can return revenue without a date" do
    merchant = create(:merchant)
    invoice = create(:invoice, merchant: merchant)
    invoice.transactions << create(:transaction)
    invoice_items = create_list(:invoice_item, 4, invoice: invoice, unit_price: 10000)

    get "/api/v1/merchants/#{merchant.id}/revenue"
    returned_revenue = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(returned_revenue[:revenue]).to eq('400.0')
  end

  it "can return revenue for a date for all merhcants" do
    merchant = create(:merchant)
    invoice = create(:invoice, merchant: merchant, created_at: DateTime.now.to_s)
    invoice.transactions << create(:transaction)
    invoice_items = create_list(:invoice_item, 4, invoice: invoice, unit_price: 10000)

    get "/api/v1/merchants/revenue?date=#{invoice.created_at}"
    returned_revenue = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_revenue[:total_revenue]).to eq('400.0')
  end

  it "can return all items for a merchant" do
    merchant = create(:merchant)
    items = create_list(:item, 6, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    returned_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_items.count).to eq(6)
  end

  it "can return all invoices for a merchant" do
    merchant = create(:merchant)
    invoices = create_list(:invoice, 6, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/invoices"

    returned_invoices = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_invoices.count).to eq(6)
  end

  it "can return a list of merchants ordered by most items by quantity" do
    inv1 = create(:invoice, :with_items, :with_transactions)
    inv2 = create(:invoice, :with_items,  item_count: 2)
    inv2.transactions << create(:transaction)
    inv3 = create(:invoice, :with_items,  item_count: 1)
    inv3.transactions << create(:transaction)
    merchant1 = create(:merchant, invoices: [inv1])
    merchant2 = create(:merchant, invoices: [inv2])
    merchant3 = create(:merchant, invoices: [inv3])
    qty = 3

    get "/api/v1/merchants/most_items?quantity=#{qty}"

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(qty)
    expect(merchants.first[:name]).to eq(merchant1.name)
    expect(merchants.last[:name]).to eq(merchant3.name)

    qty = 2

    get "/api/v1/merchants/most_items?quantity=#{qty}"

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(qty)
    expect(merchants.first[:name]).to eq(merchant1.name)
    expect(merchants.last[:name]).to eq(merchant2.name)

    qty = 1

    get "/api/v1/merchants/most_items?quantity=#{qty}"

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(qty)
    expect(merchants.first[:name]).to eq(merchant1.name)
    expect(merchants.last[:name]).to eq(merchant1.name)
  end

  it "can return a list of merchants ordered by most items for all merchant by default" do
    inv1 = create(:invoice, :with_items, :with_transactions)
    inv2 = create(:invoice, :with_items,  item_count: 2)
    inv2.transactions << create(:transaction)
    inv3 = create(:invoice, :with_items,  item_count: 1)
    inv3.transactions << create(:transaction)
    merchant1 = create(:merchant, invoices: [inv1])
    merchant2 = create(:merchant, invoices: [inv2])
    merchant3 = create(:merchant, invoices: [inv3])
    qty = 3

    get "/api/v1/merchants/most_items"

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchants.count).to eq(qty)
    expect(merchants.first[:name]).to eq(merchant1.name)
    expect(merchants.last[:name]).to eq(merchant3.name)
  end
end

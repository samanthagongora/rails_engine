require 'rails_helper'

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

  it "can return all customers with pending invoices" do
    customers = create_list(:customer, 4)
    merchant = create_list(:merchant, 2)
    invoice1 = create(:invoice, merchant: merchant[1], customer: customers[0], status: "pending")
    invoice2 = create(:invoice, merchant: merchant[0], customer: customers[1], status: "shipped")
    invoice3 = create(:invoice, merchant: merchant[1], customer: customers[2], status: "shipped")
    invoice4 = create(:invoice, merchant: merchant[0], customer: customers[3], status: "pending")

    get "/api/v1/merchants/:id/customers_with_pending_invoices"
    returned_customers = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant.count).to eq(1)
    binding.pry
    expect(returned_customers.name).to include(merchant.first[:name])
  end
end

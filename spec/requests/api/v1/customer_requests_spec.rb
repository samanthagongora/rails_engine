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
end
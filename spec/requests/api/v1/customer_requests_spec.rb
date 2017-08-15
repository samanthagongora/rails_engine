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
end

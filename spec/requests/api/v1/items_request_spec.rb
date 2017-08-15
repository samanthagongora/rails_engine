require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_success

    items = JSON.parse(response.body)

    expect(items.count).to eq 3
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(id)
  end

  it "can get one item by attribute" do
    dummy = create(:item)

    get "/api/v1/items/find?name=#{dummy.name}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(dummy.id)
  end

  xit "can get one item by another attribute" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/find?merchant_id=#{merchant.id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(id)
  end

  xit "can get all items by attribute" do
    customer = create(:customer)
    create_list(:item, 4, customer: customer)

    get "/api/v1/items/find_all?customer_id=#{customer.id}"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(4)
  end

  xit "can get all items by another attribute" do
    create_list(:item, 4, status: 'shipped')

    get "/api/v1/items/find_all?status=shipped"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(4)
  end
end

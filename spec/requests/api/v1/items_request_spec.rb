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

  it "can get one item by another attribute" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/find?merchant_id=#{merchant.id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(id)
  end

  it "can get all items by attribute" do
    merchant = create(:merchant)
    create_list(:item, 4, merchant: merchant)

    get "/api/v1/items/find_all?merchant_id=#{merchant.id}"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(4)
  end

  it "can get all items by another attribute" do
    create_list(:item, 4, unit_price:0.3421)

    get "/api/v1/items/find_all?unit_price=0.3421"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(4)
  end

  it "can return one random record" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    items = [item1.id, item2.id, item3.id]

    get "/api/v1/items/random"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(items).to include(item['id'])
  end

  it "can view the invoice items associated with it" do
    item = create(:item)
    invoice1 = create(:invoice)
    invoice2 = create(:invoice)
    3.times do
      create(:invoice_item, item_id: item.id,
             invoice_id: [invoice1.id, invoice2.id].sample)
    end

    get "/api/v1/items/#{item.id}/invoice_items"

    invoice_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(invoice_items.count).to eq(3)
    expect(invoice_items.first[:item_id]).to eq(item.id)
    expect(invoice_items.last[:item_id]).to eq(item.id)
  end

  it "can view the merchant it belongs to" do
    m1    = create(:merchant)
    m2    = create(:merchant)
    item1 = create(:item, merchant_id: m1.id)
    item2 = create(:item, merchant_id: m2.id)

    get "/api/v1/items/#{item1.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant[:id]).to eq(m1.id)
    expect(merchant[:name]).to eq(m1.name)

    get "/api/v1/items/#{item2.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant[:id]).to eq(m2.id)
    expect(merchant[:name]).to eq(m2.name)
  end
end

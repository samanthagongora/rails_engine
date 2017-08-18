require 'rails_helper'

describe "Invoice Items API" do
  it "sends a list of invoice_items" do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_success

    invoice_items = JSON.parse(response.body)

    expect(invoice_items.count).to eq 3
  end

  it "can get one invoice_item by its id" do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_item['id']).to eq(id)
  end

  it "can get one invoice_item by attribute" do
    item = create(:item)
    dummy = create(:invoice_item, item: item)

    get "/api/v1/invoice_items/find?item_id=#{item.id}"

    invoice_item = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(invoice_item[:id]).to eq(dummy.id)
  end

  it "can get one invoice_item by another attribute" do
    invoice = create(:invoice)
    dummy   = create(:invoice_item, invoice: invoice)

    get "/api/v1/invoice_items/find?invoice_id=#{invoice.id}"
    invoice_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(invoice_item[:id]).to eq(dummy.id)
  end

  it "can get all invoice_items by attribute" do
    create_list(:invoice_item, 4, quantity: 100)

    get "/api/v1/invoice_items/find_all?quantity=100"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items.count).to eq(4)
  end

  it "can get all invoice_items by another attribute" do
    create_list(:invoice_item, 4, unit_price:"13635")

    get "/api/v1/invoice_items/find_all?unit_price=136.35"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items.count).to eq(4)
  end

  it "can return one random record" do
    invoice_item1 = create(:invoice_item)
    invoice_item2 = create(:invoice_item)
    invoice_item3 = create(:invoice_item)

    invoice_items = [invoice_item1.id, invoice_item2.id, invoice_item3.id]

    get "/api/v1/invoice_items/random"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items).to include(invoice_item['id'])
  end

  it "can view the invoice it belongs to" do
    inv1 = create(:invoice)
    inv2 = create(:invoice)
    inv_item1 = create(:invoice_item, invoice_id: inv1.id)
    inv_item2 = create(:invoice_item, invoice_id: inv2.id)

    get "/api/v1/invoice_items/#{inv_item1.id}/invoice"

    invoice = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(invoice[:id]).to eq(inv1.id)
    expect(invoice[:status]).to eq(inv1.status)

    get "/api/v1/invoice_items/#{inv_item2.id}/invoice"

    invoice = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(invoice[:id]).to eq(inv2.id)
    expect(invoice[:status]).to eq(inv2.status)
  end

  it "can view the item it belongs to" do
    item1 = create(:item)
    item2 = create(:item)
    inv_item1 = create(:invoice_item, item_id: item1.id)
    inv_item2 = create(:invoice_item, item_id: item2.id)

    get "/api/v1/invoice_items/#{inv_item1.id}/item"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(item[:id]).to eq(item1.id)
    expect(item[:name]).to eq(item1.name)

    get "/api/v1/invoice_items/#{inv_item2.id}/item"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(item[:id]).to eq(item2.id)
    expect(item[:name]).to eq(item2.name)
  end
end

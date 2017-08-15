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

    invoice_item = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_item['id']).to eq(dummy.id)
  end

  it "can get one invoice_item by another attribute" do
    invoice = create(:invoice)
    id = create(:invoice_item, invoice: invoice).id

    get "/api/v1/invoice_items/find?invoice_id=#{invoice.id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_item['id']).to eq(id)
  end

  it "can get all invoice_items by attribute" do
    create_list(:invoice_item, 4, quantity: 100)

    get "/api/v1/invoice_items/find_all?quantity=100"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items.count).to eq(4)
  end

  it "can get all invoice_items by another attribute" do
    create_list(:invoice_item, 4, unit_price:0.3421)

    get "/api/v1/invoice_items/find_all?unit_price=0.3421"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice_items.count).to eq(4)
  end
end

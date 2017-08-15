require 'rails_helper'
require 'date'

describe "Items API" do
  it "sends a list of invoices" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_success

    items = JSON.parse(response.body)

    expect(items.count).to eq 3
  end

  xit "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(id)
  end

  xit "can get one invoice by one attribute" do
    invoice = create(:invoice)

    get "/api/v1/invoices/find?status=shipped"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end
end

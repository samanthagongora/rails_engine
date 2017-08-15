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

    merchant = JSON.parse(response.body)

    expect(response).to be_success
    expect(merchant["id"]).to eq(merch.id)
    expect(merchant["name"]).to eq(merch.name)
  end
end

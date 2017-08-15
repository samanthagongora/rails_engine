require 'rails_helper'

describe "Transactions API" do
  it "sends a list of transactions" do
    create_list(:transaction, 3)

    get '/api/v1/transactions'

    transactions = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(transactions.count).to eq(3)
  end

  it "can get one transaction by its id" do
    trans = create(:transaction)

    get "/api/v1/transactions/#{trans.id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_success
    expect(transaction["id"]).to eq(trans.id)
    expect(transaction["result"]).to eq(trans.result)
    expect(transaction["credit_card_number"]).to eq(trans.credit_card_number)
  end
end

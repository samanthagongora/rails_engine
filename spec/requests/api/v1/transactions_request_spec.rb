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

  it "can find a transaction by it's name" do
    create_list(:transaction, 3)
    show_trans = Transaction.first
    get "/api/v1/transactions/find?name=#{show_trans.invoice_id}"

    transaction = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(transaction[:id]).to eq(show_trans.id)
    expect(transaction[:invoice_id]).to eq(show_trans.invoice_id)
    expect(transaction[:credit_card_number]).to eq(show_trans.credit_card_number)
  end

  it "can find all transaction by shared name" do
    create_list(:transaction, 3)
    show_trans = Transaction.first
    get "/api/v1/transactions/find_all?name=#{show_trans.invoice_id}"

    transactions = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(transactions.count).to eq(3)
  end

  it "can return a random transaction" do
    i1 = create(:invoice)
    i2 = create(:invoice)
    i3 = create(:invoice)

    t1 = create(:transaction, invoice_id: i1.id)
    t2 = create(:transaction, invoice_id: i2.id)
    t3 = create(:transaction, invoice_id: i3.id)

    get "/api/v1/transactions/random"

    transaction = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_success
    expect(transaction.count).to eq(1)
    expect([t1.invoice_id, t2.invoice_id, t3.invoice_id]).to include(transaction.first[:invoice_id])
  end

  it "can return all invoices for transaction" do
    invoice = create(:invoice)
    transaction = create(:transaction, invoice: invoice)

    get "/api/v1/transactions/#{transaction.id}/invoice"

    returned_invoice = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_invoice[:id]).to eq(invoice.id)
  end
end

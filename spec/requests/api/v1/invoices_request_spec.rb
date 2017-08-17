require 'rails_helper'

describe "Invoices API" do
  it "sends a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_success

    invoices = JSON.parse(response.body)

    expect(invoices.count).to eq 3
  end

  it "can get one invoice by its id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  it "can get one invoice by attribute" do
    customer = create(:customer)
    id = create(:invoice, customer: customer).id

    get "/api/v1/invoices/find?customer_id=#{customer.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  it "can get one invoice by another attribute" do
    merchant = create(:merchant)
    id = create(:invoice, merchant: merchant).id

    get "/api/v1/invoices/find?merchant_id=#{merchant.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  it "can get all invoices by attribute" do
    customer = create(:customer)
    create_list(:invoice, 4, customer: customer)

    get "/api/v1/invoices/find_all?customer_id=#{customer.id}"

    invoices = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices.count).to eq(4)
  end

  it "can get all invoices by another attribute" do
    create_list(:invoice, 4, status: 'shipped')

    get "/api/v1/invoices/find_all?status=shipped"

    invoices = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices.count).to eq(4)
  end

  it "can return one random record" do
    invoice1 = create(:invoice)
    invoice2 = create(:invoice)
    invoice3 = create(:invoice)

    invoices = [invoice1.id, invoice2.id, invoice3.id]

    get "/api/v1/invoices/random"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoices).to include(invoice['id'])
  end

  it "can view the transactions associated with it" do
    inv = create(:invoice)
    3.times do
      create(:transaction, invoice_id: inv.id)
    end

    get "/api/v1/invoices/#{inv.id}/transactions"

    transactions = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(transactions.count).to eq(3)
    expect(transactions.first[:invoice_id]).to eq(inv.id)
    expect(transactions.last[:invoice_id]).to eq(inv.id)
  end

  it "can view the invoice items associated with it" do
    inv = create(:invoice)
    item1 = create(:item)
    item2 = create(:item)
    3.times do
      create(:invoice_item, invoice_id: inv.id,
             item_id: [item1.id, item2.id].sample)
    end

    get "/api/v1/invoices/#{inv.id}/invoice_items"

    invoice_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(invoice_items.count).to eq(3)
    expect(invoice_items.first[:invoice_id]).to eq(inv.id)
    expect(invoice_items.last[:invoice_id]).to eq(inv.id)
  end

  it "can view the items associated with it" do
    inv = create(:invoice)
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)
    create(:invoice_item, invoice_id: inv.id, item_id: item1.id)
    create(:invoice_item, invoice_id: inv.id, item_id: item2.id)
    create(:invoice_item, invoice_id: inv.id, item_id: item3.id)

    get "/api/v1/invoices/#{inv.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(items.count).to eq(3)
    expect(items.first[:name]).to eq(item1.name)
  end


  it "can view the customer it belongs to" do
    cust1 = create(:customer)
    cust2 = create(:customer)

    inv1 = create(:invoice, customer_id: cust1.id)
    inv2 = create(:invoice, customer_id: cust2.id)

    get "/api/v1/invoices/#{inv1.id}/customer"

    customer = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(customer[:id]).to eq(cust1.id)
    expect(customer[:first_name]).to eq(cust1.first_name)

    get "/api/v1/invoices/#{inv2.id}/customer"

    customer = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(customer[:id]).to eq(cust2.id)
    expect(customer[:first_name]).to eq(cust2.first_name)
  end

  it "can view the merchant it belongs to" do
    merch1 = create(:merchant)
    merch2 = create(:merchant)

    inv1 = create(:invoice, merchant_id: merch1.id)
    inv2 = create(:invoice, merchant_id: merch2.id)

    get "/api/v1/invoices/#{inv1.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant[:id]).to eq(merch1.id)
    expect(merchant[:name]).to eq(merch1.name)

    get "/api/v1/invoices/#{inv2.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(merchant[:id]).to eq(merch2.id)
    expect(merchant[:name]).to eq(merch2.name)
  end
end

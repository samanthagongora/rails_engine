require 'rails_helper'

describe "Invoices API" do
  it "sends a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_success

    invoices = JSON.parse(response.body)

    expect(invoices.count).to eq 3
  end

  xit "can get one invoice by its id" do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_success
    expect(invoice['id']).to eq(id)
  end

  xit "can create a new invoice" do
    invoice_params = { name: "saw",
                    description: "I want to play a game" }

    post "/api/v1/invoices", params:{ invoice: invoice_params }
    invoice = Invoice.last

    assert_response :success
    expect(response).to be_success

    expect(invoice.name).to eq(invoice_params[:name])
  end

  xit "can update an existing invoice" do
    id = create(:invoice).id
    previous_name = Invoice.last.name
    invoice_params = { name: "Sledge" }

    put "/api/v1/invoices/#{id}", params: {invoice: invoice_params}
    invoice = Invoice.find_by(id: id)

    expect(response).to be_success
    expect(invoice.name).to_not eq(previous_name)
    expect(invoice.name).to eq("Sledge")
  end

  xit "can destroy an invoice" do
    invoice = create(:invoice)

    expect(Invoice.count).to eq(1)

    # this is another way:
    # expect{delete "/api/v1/invoices/#{invoice.id}"}.to change(invoice, :count).by(-1)

    delete "/api/v1/invoices/#{invoice.id}"

    expect(response).to be_success
    expect(Invoice.count).to eq(0)
    expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end

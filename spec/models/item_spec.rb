require 'rails_helper'

RSpec.describe Item, type: :model do
  it { is_expected.to have_many(:invoice_items) }
  it { is_expected.to have_many(:invoices) }
  it { is_expected.to belong_to(:merchant) }
end

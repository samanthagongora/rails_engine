require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:invoice_items) }
    it { is_expected.to have_many(:items) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to belong_to(:customer) }
  end
end

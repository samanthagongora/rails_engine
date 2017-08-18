FactoryGirl.define do
  factory :invoice_item do
    invoice
    item
    quantity 1
    unit_price "9.99"
  end
end

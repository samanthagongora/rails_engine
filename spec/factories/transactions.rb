FactoryGirl.define do
  factory :transaction do
    invoice nil
    credit_card_number "MyString"
    result 1
  end
end

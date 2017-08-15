FactoryGirl.define do
  factory :invoice do
    status 0
    customer
    merchant
  end
end

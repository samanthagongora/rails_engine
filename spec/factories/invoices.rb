FactoryGirl.define do
  factory :invoice do
    status 1
    customer
    merchant
  end
end

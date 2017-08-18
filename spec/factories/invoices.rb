FactoryGirl.define do
  factory :invoice do
    status 0
    customer
    merchant
  end

  trait :with_items do
    transient do
      item_count 3
    end

    after(:create) do |invoice, evaluator|
      invoice.items << create_list(:item, evaluator.item_count)
    end
  end

  trait :with_transactions do
    transient do
      transaction_count 1
    end

    after(:create) do |invoice, evaluator|
      invoice.transactions << create_list(:transaction, evaluator.transaction_count)
    end
  end
end

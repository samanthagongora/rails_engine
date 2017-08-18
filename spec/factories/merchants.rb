FactoryGirl.define do
  factory :merchant do
    name "Mark's Martial Arts Makeup Dojo"

    trait :with_invoices do
      transient do
        invoice_count 1
      end

      # trait :with_items do
      #   transient do
      #     item_count 3
      #   end
      #
      #   after(:create) do |invoice, evaluator|
      #     invoice.items << create_list(:item, evaluator.item_count)
      #   end
      # end
      #
      # trait :with_transactions do
      #   transient do
      #     transaction_count 3
      #   end
      #
      #   after(:create) do |invoice, evaluator|
      #     invoice.transactions << create_list(:transaction, evaluator.transaction_count)
      #   end
      # end

      after(:create) do |merchant, evaluator|
        merchant.invoices << create_list(:invoice, evaluator.invoice_count)
      end
    end
  end
end

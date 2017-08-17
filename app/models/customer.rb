class Customer < ApplicationRecord
  has_many :invoices

  def favorite_merchant
    Merchant.joins(:invoices)
            .joins("INNER JOIN transactions
                    ON transactions.invoice_id = invoices.id")
            .where(invoices: {customer_id: self.id}, transactions: {result: 0})
            .group(:id)
            .order("count(transactions.id) DESC")
            .first
  end
end

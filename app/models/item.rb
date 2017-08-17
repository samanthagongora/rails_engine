class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.most_revenue(quantity)
    joins(:invoice_items)
    .joins(invoices: [:transactions])
    .where(transactions: {result: 0})
    .group(:id)
    .order("sum(invoice_items.unit_price * invoice_items.quantity) DESC")
    .limit(quantity)
  end
end

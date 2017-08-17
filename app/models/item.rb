class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.most_items(quantity=Item.count)
    joins(:invoice_items)
    .joins("INNER JOIN invoices ON invoice_items.invoice_id = invoices.id")
    .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id")
    .where(transactions: {result: 0})
    .group(:id)
    .order("count(invoice_items.item_id) DESC")
    .limit(quantity)
  end

  def best_day
    invoices.joins(:invoice_items)
            .group(:id, "invoices.created_at")
            .order("sum(invoice_items.quantity) DESC, invoices.created_at DESC")
            .first.created_at
   end
end

class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def revenue_by_date(date=nil)
    if date.nil?
      amount = invoices
      .joins("INNER JOIN invoice_items
              ON invoices.id = invoice_items.invoice_id")
      .joins("INNER JOIN transactions
              ON transactions.invoice_id = invoices.id")
      .where(transactions: {result: 0})
      .sum("invoice_items.unit_price * invoice_items.quantity")
    else
      amount = invoices
      .where(["invoices.created_at::date = ?", date.to_datetime])
      .joins(:invoice_items)
      .sum("invoice_items.quantity * invoice_items.unit_price")
    end
    to_dollars(amount)
  end

  def self.most_items(quantity=Merchant.count)
    joins(:invoices)
    .joins("INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id")
    .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id")
    .where(transactions: {result: 0})
    .group(:id)
    .order("sum(invoice_items.quantity) DESC")
    .limit(quantity)
  end


  private

  def to_dollars(amount)
    total_rev = amount.to_f/100
    total_rev.to_s
  end
end

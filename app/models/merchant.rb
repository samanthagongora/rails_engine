require 'date'

class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  has_many :invoice_items, through: :invoices

  def favorite_customer
    Customer
    .joins(:invoices, :transactions)
    .where(invoices: { merchant_id: self.id }, transactions: {result: 'success'})
    .group(:id)
    .order("count(transactions) DESC")
    .limit(1)
  end

  def revenue_by_date(date)
    invoices
    .where(["invoices.created_at::date = ?", date.to_datetime])
    .joins(:invoice_items)
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def self.most_revenue(quantity)
    joins(:invoices).joins(:invoice_items).sum("(invoice_items.quantity * invoice_items.unit_price) as total_revenue").group(:id).order("total_revenue DESC")
  end
end

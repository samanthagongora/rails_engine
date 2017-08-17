require 'date'

class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

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
    .select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
  end

  def self.most_revenue(quantity)
    joins(invoices: [:invoice_items])
    .joins(invoices: [:transactions])
    .where(transactions: {result: 0})
    .group(:id)
    .order("sum(invoice_items.unit_price * invoice_items.quantity) DESC")
    .limit(quantity)
  end
end

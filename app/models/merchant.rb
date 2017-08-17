require 'date'

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

  def favorite_customer
    Customer
    .joins(:invoices, :transactions)
    .where(invoices: { merchant_id: self.id }, transactions: {result: 'success'})
    .group(:id)
    .order("count(transactions) DESC")
    .limit(1)
  end

  def self.most_revenue(quantity)
    joins(invoices: [:invoice_items])
    .joins(invoices: [:transactions])
    .where(transactions: {result: 0})
    .group(:id)
    .order("sum(invoice_items.unit_price * invoice_items.quantity) DESC")
    .limit(quantity)
  end

  def self.all_revenue_by_date(date)
    amount = find_by_sql("SELECT sum(ii.unit_price * ii.quantity) AS total_revenue
                 FROM merchants m
                 INNER JOIN invoices i ON i.merchant_id = m.id
                 INNER JOIN invoice_items ii ON ii.invoice_id = i.id
                 INNER JOIN transactions t ON t.invoice_id = i.id
                 WHERE t.result = 0 AND i.created_at = '#{date}'
                 ORDER BY total_revenue DESC").first['total_revenue']
    to_dollars(amount)
  end

  private

  def to_dollars(amount)
    total_rev = amount.to_f/100
    total_rev.to_s
  end

  def self.to_dollars(amount)
    total_rev = amount.to_f/100
    total_rev.to_s
  end
end

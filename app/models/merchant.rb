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

  def customers_with_pending_invoices
    Customer.find_by_sql(
      "SELECT customers.*
      FROM customers
      INNER JOIN invoices ON invoices.customer_id = customers.id
      INNER JOIN merchants ON merchants.id = invoices.merchant_id
      INNER JOIN transactions ON transactions.invoice_id = invoices.id
      WHERE merchants.id = #{self.id} AND transactions.result = 1

      EXCEPT

      SELECT customers.*
      FROM customers
      INNER JOIN invoices ON invoices.customer_id = customers.id
      INNER JOIN merchants ON merchants.id = invoices.merchant_id
      INNER JOIN transactions ON transactions.invoice_id = invoices.id
      WHERE merchants.id = #{self.id} AND transactions.result = 0"
    )
  end
end

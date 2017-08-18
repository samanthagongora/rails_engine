# Rales Engine
[Project Spec](http://backend.turing.io/module3/projects/rails_engine)

Use Rails and ActiveRecord to build a JSON API which exposes the SalesEngine data schema

##Contributors
[Sam Gongora](https://github.com/samanthagongora)
[Will Ratterman](https://github.com/wratterman)

## Installing / Getting started

To setup on project/database on your local drive...

```shell
git clone git@github.com:wratterman/rails_engine.git
cd rails_engine
bundle
rake db:create db:migrate import:all_csv
```

Here you are seeding your database with [sales engine data](https://github.com/turingschool-examples/sales_engine/tree/master/data).

## Endpoints

Below are a list of possible API Endpoints that you may visit.

First, run `rails s`.

`localhost:3000/api/v1/merchants/` returns a collection of all merchants
`localhost:3000/api/v1/merchants/:merchant_id` returns an instance of specific merchants by the unique id of that merchant
`localhost:3000/api/v1/customers/` returns a collection of all customers
`localhost:3000/api/v1/customers/:customer_id` returns an instance of specific customers by the unique id of that customer
`localhost:3000/api/v1/invoices/` returns a collection of all invoices
`localhost:3000/api/v1/invoices/:invoice_id` returns an instance of specific invoices by the unique id of that invoice
`localhost:3000/api/v1/items/` returns a collection of all items
`localhost:3000/api/v1/items/:item_id` returns an instance of specific items by the unique id of that item
`localhost:3000/api/v1/invoice_items/` returns a collection of all invoice_items
`localhost:3000/api/v1/invoice_items/:invoice_item_id` returns an instance of specific invoice_items by the unique id of that invoice_item
`localhost:3000/api/v1/transactions/` returns a collection of all transactions
`localhost:3000/api/v1/transactions/:transaction_id` returns an instance of specific transactions by the unique id of that transaction


### Relationship Endpoints

Below are a list of possible API Relationship Endpoints that you may visit.

First, run `rails s`.

####Merchants

`localhost:3000/api/v1/merchants/:id/items` returns a collection of items associated with that merchant
`localhost:3000/api/v1/merchants/:id/invoices` returns a collection of invoices associated with that merchant from their known orders

####Invoices

`localhost:3000/api/v1/invoices/:id/transactions` returns a collection of associated transactions
`localhost:3000/api/v1/invoices/:id/invoice_items` returns a collection of associated invoice items
`localhost:3000/api/v1/invoices/:id/items returns` a collection of associated items
`localhost:3000/api/v1/invoices/:id/customer` returns the associated customer
`localhost:3000/api/v1/invoices/:id/merchant` returns the associated merchant

####Invoice Items

`localhost:3000/api/v1/invoice_items/:id/invoice` returns the associated invoice
`localhost:3000/api/v1/invoice_items/:id/item` returns the associated item

####Items

`localhost:3000/api/v1/items/:id/invoice_items` returns a collection of associated invoice items
`localhost:3000/api/v1/items/:id/merchant` returns the associated merchant

####Transactions

`localhost:3000/api/v1/transactions/:id/invoice` returns the associated invoice

####Customers

`localhost:3000/api/v1/customers/:id/invoices` returns a collection of associated invoices
`localhost:3000/api/v1/customers/:id/transactions` returns a collection of all invoice_items


## Business Intelligence

Below are a list of possible API Business Intelligence that you may visit.

First, run `rails s`

####All Merchants

`localhost:3000/api/v1/merchants/most_revenue?quantity=x` returns the top `x` merchants ranked by total revenue
`localhost:3000/api/v1/merchants/most_items?quantity=x` returns the top `x` merchants ranked by total number of items sold
`localhost:3000/api/v1/merchants/revenue?date=x` returns the total revenue for date `x` across all merchants

####Single Merchant

`localhost:3000/api/v1/merchants/:id/revenue` returns the total revenue for that merchant across successful transactions
`localhost:3000/api/v1/merchants/:id/revenue?date=x` returns the total revenue for that merchant for a specific invoice date `x`
`localhost:3000/api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the most total number of successful transactions.
`localhost:3000/api/v1/merchants/:id/customers_with_pending_invoices` returns a collection of customers which have pending (unpaid) invoices. A pending invoice has no transactions with a result of success.

####Items

`localhost:3000/api/v1/items/most_revenue?quantity=x` returns the top `x` items ranked by total revenue generated
`localhost:3000/api/v1/items/most_items?quantity=x` returns the top `x` item instances ranked by total number sold
`localhost:3000/api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.

####Customers

`localhost:3000/api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions

## Spec Harness

The Spec Harness for this project can be found [Here](https://github.com/turingschool/rales_engine_spec_harness)

To run the spec harness, run the following

```
cd ..
git clone https://github.com/turingschool/rales_engine_spec_harness.git
cd rales_engine_spec_harness
bundle
```

in `../rails_engine`
```
rails s
```

in `../rales_engine_spec_harness_engine`
```
rake
=> #runs the spec harness
```
###NOTE
You need to be running `rails s` before running the spec harness!

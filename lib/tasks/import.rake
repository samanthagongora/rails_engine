require 'csv'

desc "Import customers from csv file"
task :import => [:environment] do

    file = "db/csv/customers.csv"

    CSV.foreach(file, :headers => true) do |row|
      Customer.create {
        :first_name => row[1],
        :last_name  => row[2],
        :created_at => row[3],
        :updated_at => row[4]
      }
    index  = 0
    amount = 999
    puts "#{amount} - #{index} Customers Remaining!"
    index +=1
  end
end

desc "Import invoice items from csv file"
task :import => [:environment] do

  file = "db/csv/invoice_items.csv"

  CSV.foreach(file, :headers => true) do |row|
    InvoiceItem.create {
      :item_id     => row[1],
      :invoice_id  => row[2],
      :quantity    => row[3],
      :unit_price  => row[4],
      :created_at  => row[5],
      :updated_at  => row[6]
    }
    index  = 0
    amount = 21687
    puts "#{amount} - #{index} Invoice Items Remaining!"
    index +=1
  end
end

desc "Import invoices from csv file"
task :import => [:environment] do

  file = "db/csv/invoices.csv"

  CSV.foreach(file, :headers => true) do |row|
    Invoice.create {
      :customer_id => row[1],
      :merchant_id => row[2],
      :status      => row[3],
      :created_at  => row[4],
      :updated_at  => row[5]
    }
    index  = 0
    amount = 4843
    puts "#{amount} - #{index} Invoices Remaining!"
    index +=1
  end
end

desc "Import items from csv file"
task :import => [:environment] do

  file = "db/csv/items.csv"

  CSV.foreach(file, :headers => true) do |row|
    Item.create {
      :name        => row[1],
      :description => row[2],
      :unit_price  => row[3],
      :merchant_id => row[4],
      :created_at  => row[5],
      :updated_at  => row[6]
    }
    index  = 0
    amount = 2483
    puts "#{amount} - #{index} Items Remaining!"
    index += 1
  end
end

desc "Import merchants from csv file"
task :import => [:environment] do

  file = "db/csv/merchants.csv"

  CSV.foreach(file, :headers => true) do |row|
    Merchant.create {
      :name        => row[1],
      :created_at  => row[2],
      :updated_at  => row[3]
    }
    index  = 0
    amount = 99
    puts "#{amount} - #{index} Merchants Remaining!"
    index += 1
  end
end

desc "Import transactions from csv file"
task :import => [:environment] do

  file = "db/csv/transactions.csv"

  CSV.foreach(file, :headers => true) do |row|
    Transaction.create {
      :invoice_id         => row[1],
      :credit_card_number => row[2],
      :result             => row[4],
      :created_at         => row[5],
      :updated_at         => row[6]
    }
    index  = 0
    amount = 5594
    puts "#{amount} - #{index} Transactions Remaining!"
    index += 1
  end
end

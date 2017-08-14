require 'csv'

desc "Import all CSVs"
  desc "Import merchants from csv file"

  task :import => [:environment] do

    file = "db/csv/merchants.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Merchant.create!({
        :name         => row[1],
        :created_at   => row[2],
        :updated_at   => row[3]
      })
      amount = 99
      puts "#{amount - index}" + " " +  "Merchants Remaining!"
      index += 1
    end
  end

  desc "Import items from csv file"
  task :import => [:environment] do

    file = "db/csv/items.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Item.create!({
        :name        => row[1],
        :description => row[2],
        :unit_price  => row[3],
        :merchant_id => row[4],
        :created_at  => row[5],
        :updated_at  => row[6]
      })
      amount = 2483
      puts "#{amount - index}" + " " +  "Items Remaining!"
      index += 1
      # binding.pry if (amount - index) < 0
    end
  end

  desc "Import customers from csv file"
  task :import => [:environment] do

      file = "db/csv/customers.csv"
      index  = 0
      CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
        Customer.create!({
          :first_name => row[1],
          :last_name  =>  row[2],
          :created_at => row[3],
          :updated_at => row[4]
        })

      amount = 999
      puts "#{amount - index}" + " " +  "Customers Remaining!"
      index +=1
    end
  end

  desc "Import invoices from csv file"
  index  = 0
  task :import => [:environment] do

    file = "db/csv/invoices.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Invoice.create!({
        :customer_id  => row[1],
        :merchant_id  => row[2],
        :status       => row[3],
        :created_at   => row[4],
        :updated_at   => row[5]
      })
      amount = 4843
      puts "#{amount - index}" + " " +  "Invoices Remaining!"
      index +=1
    end
  end

  desc "Import transactions from csv file"
  task :import => [:environment] do

    file = "db/csv/transactions.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Transaction.create!({
        :invoice_id         => row[1],
        :credit_card_number => row[2],
        :result             => row[4],
        :created_at         => row[5],
        :updated_at         => row[6]
      })
      amount = 5594
      puts "#{amount - index}" + " " +  "Transactions Remaining!"
      index += 1
    end
  end

  desc "Import invoice items from csv file"
  task :import => [:environment] do

    file = "db/csv/invoice_items.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      InvoiceItem.create!({
        :item_id    => row[1],
        :invoice_id => row[2],
        :quantity   => row[3],
        :unit_price => row[4],
        :created_at => row[5],
        :updated_at => row[6]
      })
      amount = 21687
      puts "#{amount - index}" + " " +  "Invoice Items Remaining!"
      index +=1
    end
  end

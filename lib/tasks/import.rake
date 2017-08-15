require 'csv'


namespace :import do
  desc "Import all CSVs"
  task all_csv: ['import:merchants', 'import:items', 'import:customers',
                 'import:invoices', 'import:transactions',
                 'import:invoice_items']


  desc "Import merchants from csv file"

  task :merchants => [:environment] do

    file = "db/csv/merchants.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Merchant.create!({
        :name         => row[:name],
        :created_at   => row[:created_at],
        :updated_at   => row[:updated_at]
      })
      amount = 99
      puts "#{amount - index}" + " " +  "Merchants Remaining!"
      index += 1
    end
  end

  desc "Import items from csv file"
  task :items => [:environment] do

    file = "db/csv/items.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Item.create!({
        :name         => row[:name],
        :description  => row[:description],
        :unit_price   => row[:unit_price],
        :merchant_id  => row[:merchant_id],
        :created_at   => row[:created_at],
        :updated_at   => row[:updated_at]
      })
      amount = 2483
      puts "#{amount - index}" + " " +  "Items Remaining!"
      index += 1
      # binding.pry if (amount - index) < 0
    end
  end

  desc "Import customers from csv file"
  task :customers => [:environment] do

      file = "db/csv/customers.csv"
      index  = 0
      CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
        Customer.create!({
          :first_name   => row[:first_name],
          :last_name    =>  row[:last_name],
          :created_at   => row[:created_at],
          :updated_at   => row[:updated_at]
        })

      amount = 999
      puts "#{amount - index}" + " " +  "Customers Remaining!"
      index +=1
    end
  end

  desc "Import invoices from csv file"
  index  = 0
  task :invoices => [:environment] do

    file = "db/csv/invoices.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Invoice.create!({
        :customer_id  => row[:customer_id],
        :merchant_id  => row[:merchant_id],
        :status       => row[:status],
        :created_at   => row[:created_at],
        :updated_at   => row[:updated_at]
      })
      amount = 4843
      puts "#{amount - index}" + " " +  "Invoices Remaining!"
      index +=1
    end
  end

  desc "Import transactions from csv file"
  task :transactions => [:environment] do

    file = "db/csv/transactions.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      Transaction.create!({
        :invoice_id         => row[:invoice_id],
        :credit_card_number => row[:credit_card_number],
        :result             => row[:result],
        :created_at         => row[:created_at],
        :updated_at         => row[:updated_at]
      })
      amount = 5594
      puts "#{amount - index}" + " " +  "Transactions Remaining!"
      index += 1
    end
  end

  desc "Import invoice items from csv file"
  task :invoice_items => [:environment] do

    file = "db/csv/invoice_items.csv"
    index  = 0
    CSV.foreach(file, :headers => true, header_converters: :symbol) do |row|
      InvoiceItem.create!({
        :item_id    => row[:item_id],
        :invoice_id => row[:invoice_id],
        :quantity   => row[:quantity],
        :unit_price => row[:unit_price],
        :created_at => row[:created_at],
        :updated_at => row[:updated_at]
      })
      amount = 21687
      puts "#{amount - index}" + " " +  "Invoice Items Remaining!"
      index +=1
    end
    puts "DB seeded!"
  end
end

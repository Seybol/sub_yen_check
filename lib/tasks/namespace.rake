require 'currency_parse'
task send_email: :environment do
  parser = CurrencyParse.new(117)
  parser.execute
end

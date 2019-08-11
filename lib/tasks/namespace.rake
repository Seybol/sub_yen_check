require 'currency_parse'
task send_email: :environment do
  parser = CurrencyParse.new(115)
  parser.execute
en

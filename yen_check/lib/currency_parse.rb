require 'mailgun-ruby'
require 'dotenv'

class CurrencyParse
  def initialize(minimum_price)
    @api_key = ENV.fetch('MAILGUN_API_KEY')
    @domain_name = ENV.fetch('MAILGUN_DOMAIN_NAME')
    @minimum_price = minimum_price
    @mail = ''
    @companies = initialize_companies
    @selected_companies = {}
  end

  def execute
    find_prices
    return unless at_least_one_good_price?

    create_mail
    send_email
  end

  private

  def initialize_companies
    companies = {}
    companies[:cen_change] = {}
    companies[:cen_change][:name] = 'CEN-CHANGE'
    companies[:cen_change][:url] = 'https://www.cen-change.com/'

    companies[:magenta] = {}
    companies[:magenta][:name] = 'CHANGE MAGENTA'
    companies[:magenta][:url] = 'http://www.changemagenta.fr/devises/cours/prix.html'
    companies
  end

  def create_mail
    @selected_companies.each do |company|
      name = company[1][:name]
      url = company[1][:url]
      price = company[1][:price]
      @mail << "#{name} sells #{price} for 1 euro.\nGo to : #{url} \n"
    end
  end

  def send_email
    mg_client = Mailgun::Client.new @api_key
    message_params = { from: "Seb <mailgun@#{@domain_name}>",
                       to: 'sebastien.cebula@gmail.com',
                       subject: 'Cours du YEN',
                       text: @mail }
    mg_client.send_message @domain_name, message_params
  end

  def at_least_one_good_price?
    @companies.each do |company|
      key = company[0]
      price = company[1][:price]
      @selected_companies[key] = @companies[key] if price > @minimum_price
    end
    return true if @selected_companies.count.positive?

    false
  end

  def find_prices
    find_cen_change_price
    find_magenta_price
  end

  def find_magenta_price
    magenta = Nokogiri::HTML(open('http://www.changemagenta.fr/devises/cours/prix.html'))
    @companies[:magenta][:price] =
      magenta.css('.tableauItem')
             .css('tr:nth-child(6)')
             .css('td:nth-child(2)')
             .text
             .squish
             .split[3]
             .to_f
  end

  def find_cen_change_price
    cen_change = Nokogiri::HTML(open('https://www.cen-change.com/'))
    @companies[:cen_change][:price] =
      cen_change.css('#blog > div > div:nth-child(1) > div.themeple_sc.span12 > div > div:nth-child(1) > form > table:nth-child(3)')
                .text
                .squish
                .split[6]
                .to_f
  end
end

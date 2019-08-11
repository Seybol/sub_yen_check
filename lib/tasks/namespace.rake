task send_email: :environment do
  doc = Nokogiri::HTML(open('https://www.cen-change.com/'))
  yen = doc.css('#blog > div > div:nth-child(1) > div.themeple_sc.span12 > div > div:nth-child(1) > form > table:nth-child(3)').text.squish.split[6].to_f
115.5
  # abort("Yen is too low") unless yen > 116

  require 'mailgun-ruby'
  require 'dotenv'
  api_key = ENV.fetch('MAILGUN_API_KEY')
  domain_name = ENV.fetch('MAILGUN_DOMAIN_NAME')
  # First, instantiate the Mailgun Client with your API key
  mg_client = Mailgun::Client.new api_key
  
  # Define your message parameters
  # message_params =  { from: 'Excited User <mailgun@sandbox0be5a2921155402796b42764dc373d8a.mailgun.org',
  message_params =  { from: "Seb <mailgun@#{domain_name}>",
                      to:   'sebastien.cebula@gmail.com',
                      subject: 'Cours du YEN',
                      text:    "Actuellement #{yen} !!"
                    }
  
  # Send your message through the client
  begin
    mg_client.send_message "#{domain_name}", message_params
  rescue => exception
    puts '___________________________________'
    puts '__________ERROR__________'
    puts '___________________________________'
  end
end

task send_email: :environment do
  doc = Nokogiri::HTML(open('https://www.cen-change.com/'))
  yen = doc.css('#blog > div > div:nth-child(1) > div.themeple_sc.span12 > div > div:nth-child(1) > form > table:nth-child(3)').text.squish.split[6].to_f
115.5
  # abort("Yen is too low") unless yen > 116

  require 'mailgun-ruby'
  # First, instantiate the Mailgun Client with your API key
  mg_client = Mailgun::Client.new '98ecfa09a3ce4a6d5619a6feb5908441-73ae490d-8cc802fe'
  
  # Define your message parameters
  # message_params =  { from: 'Excited User <mailgun@sandbox0be5a2921155402796b42764dc373d8a.mailgun.org',
  message_params =  { from: 'Seb <mailgun@sandbox0be5a2921155402796b42764dc373d8a.mailgun.org>',
                      to:   'sebastien.cebula@gmail.com',
                      subject: 'Cours du YEN',
                      text:    "Actuellement #{yen} !!"
                    }
  
  # Send your message through the client
  begin
    mg_client.send_message 'sandbox0be5a2921155402796b42764dc373d8a.mailgun.org', message_params
  rescue => exception
    puts '___________________________________'
    puts '__________ERROR__________'
    puts '___________________________________'
  end
end

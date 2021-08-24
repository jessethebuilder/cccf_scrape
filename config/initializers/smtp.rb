Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  host = 'cccf-roster.herokuapp.com' #replace with your own url
  config.action_mailer.default_url_options = { host: host }

  # SMTP settings for gmail
  config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => Rails.application.credentials.email_user,
  :password             => Rails.application.credentials.email_password,
  :authentication       => "plain",
  :enable_starttls_auto => true,

  }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
end

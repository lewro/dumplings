#Mailer -Using Gooogle Apps
ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address        => "smtp.gmail.com",
  :port           => 587,
  :domain         => "getquantify.com",
  :authentication => :plain,
  :user_name      => "support@getquantify.com",
  :password       => "namor070"
}

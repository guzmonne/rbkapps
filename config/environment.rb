# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rbkapps::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address => "mail.rivani.com.uy",
    :domain => "rivani.com.uy",
    :port => 587,
    :user_name => "gmonne@rivani.com.uy",
    :password => "Guxmaster*6151",
    :authentication => "login",
    :enable_starttls_auto => true
}
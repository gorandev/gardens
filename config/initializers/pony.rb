if ENV["RAILS_ENV"] == 'development'
  Pony.options = {
    :via => :smtp,
    :via_options => {
      :address => 'localhost',
      :port => '25',
      :domain => 'mondongo.com.ar'
    }
  }
end

if ENV["RAILS_ENV"] == 'production'
  Pony.options = {
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'idashboard.la',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  }
end
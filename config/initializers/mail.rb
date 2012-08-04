# quick hack to export key/secret to env in develement from omniauth_github.yml
# These will need to be exported on heroku
if Rails.env.development?
  sendgrid_yaml = File.expand_path('../../sendgrid.yml', __FILE__)
  if File.exists?(sendgrid_yaml)
    data = HashWithIndifferentAccess.new(YAML.load(File.read(sendgrid_yaml)))
    data.each do |key, value| 
      ENV[key.to_s.upcase] = value
    end
  end
end
unless Rails.env.test
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => ENV['SENDGRID_DOMAIN']
}
ActionMailer::Base.delivery_method = :smtp
end

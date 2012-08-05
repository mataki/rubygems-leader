# quick hack to export key/secret to env in develement from omniauth_github.yml
# These will need to be exported on heroku
unless Rails.env.production?
  omniauth_yaml = File.expand_path('../../oauth_github.yml', __FILE__)
  if File.exists?(omniauth_yaml)
    omni_data = HashWithIndifferentAccess.new(YAML.load(File.read(omniauth_yaml)))
    omni_data.each do |key, value|
      ENV[key.to_s.upcase] = value
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"], skip_info: true
  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }
end

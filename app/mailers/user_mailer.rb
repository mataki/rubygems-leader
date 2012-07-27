class UserMailer < ActionMailer::Base
  default from: "noreply@rubygems-leader.herokuapp.com"
  def claim_identity(url, to)
    return unless url
    @url = url
    mail(:to => to, :subject => "Get your Coderwall Badges")
  end
end

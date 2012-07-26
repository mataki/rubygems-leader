class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def claim_identity(user)
    return unless user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Get your Coderwall Badges")
  end
end

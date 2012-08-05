class UserMailer < ActionMailer::Base
  default :from => 'no-reply@rubygems-leader.herokuapp.com'

  def claim_identity(url, recipient)
    @url = url
    mail(:to => recipient, :subject => "[Rubygems-leader] Authorize your GitHub account")
  end
end

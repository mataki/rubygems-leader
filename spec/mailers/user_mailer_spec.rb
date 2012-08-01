require "spec_helper"

describe UserMailer do
  describe 'claim identity' do

    before :each do
      claim_identity_key = mock_model(ClaimIdentityKey)
      gh_user = mock_model(GithubUser)
      @url = github_user_confirm_identity_path(gh_user, key: claim_identity_key.key, only_path: false)
      @email = gh_user.email
    end

    it 'renders without error' do
      lambda { UserMailer.claim_identity(@url, @email).deliver }.should_not raise_error
    end

    describe 'has proper content' do
      before :each do
        @mailer = UserMailer.claim_identity(@url, @email)
      end
      it 'showing the claim url' do
        @mailer.body.should have_selector('a', content: @url)
      end
    end
  end
end




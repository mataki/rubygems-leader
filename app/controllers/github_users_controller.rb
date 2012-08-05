class GithubUsersController < ApplicationController

  before_filter :ensure_active_github_user, only: [:show, :request_identity]

  def show
    @github_user = GithubUser.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @github_user.to_json }
    end
  end

  def request_identity
    github_user = GithubUser.find(params[:github_user_id])
    if claim_identity_key = github_user.request_identity(params[:user_handle])
      url = request_identity_url(github_user, claim_identity_key.key)
      @success = UserMailer.claim_identity(url, claim_identity_key.email).deliver
    end
    render partial: 'request_identity', layout: false
  end

  def confirm_identity
    if github_user = GithubUser.confirm_identity(params[:key])
      session[:user_id] = github_user.user.id
      redirect_to root_path, notice: "Accounts successfully linked."
    else
      redirect_to root_path, alert: "The computer says: 'No.'"
    end

  end
  def ensure_active_github_user
    if session[:github_user_id].nil?
      redirect_to root_path, alert:  "You must login with github before accessing your account."
    elsif session[:github_user_id].to_i != (params[:id] || params[:github_user_id]).to_i
      redirect_to root_path, alert: "Oops! I think you have the wrong url there."
    end
  end

  private

  def request_identity_url(github_user, key)
    github_user_confirm_identity_path(github_user, key: key, only_path: false)
  end
end

class SessionsController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    github_user = GithubUser.authenticate(omniauth_hash)
    update_session github_user
    redirect_to session[:user_id] ? root_path : github_user_path(github_user)
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private

  def update_session github_user
    session[:user_id] = github_user.user.id if github_user.user
    session[:github_user_id] = github_user.id
  end

  def omniauth_hash
    request.env['omniauth.auth']
  end

end

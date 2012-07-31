class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :miniprofiler

  private

  def miniprofiler
    Rack::MiniProfiler.authorize_request if params[:miniprofiler].present?
  end

  def auth_failure
    redirect_to root_path, alert: params[:message]
     redirect_to root_path, alert: params[:message]
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
end

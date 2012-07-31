class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :miniprofiler

private

  def miniprofiler
    Rack::MiniProfiler.authorize_request if params[:miniprofiler].present?
  end
end

class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.order("rank ASC, total_downloads DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
end

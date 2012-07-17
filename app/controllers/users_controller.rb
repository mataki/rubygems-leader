class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    per = params[:per].present? ? params[:per].to_i : 25
    @users = User.order("rank ASC, total_downloads DESC")
    page = if params[:user].present?
             if user_page = User.find_page_by_handle(params[:user], per)
               user_page
             else
               flash.now[:alert] = "User not found"
               1
             end
           else
             params[:page]
           end
    @users = @users.page(page)
    @users = @users.per(per)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
end

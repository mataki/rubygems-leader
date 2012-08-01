class UsersController < ApplicationController

  def index
    per = params[:per].present? ? params[:per].to_i : 25
    @users = User.order("rank ASC, total_downloads DESC")
    @users = @users.page(trans_handle_to_page(params[:page], per))
    @users = @users.per(per)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users.to_json(except: :email) }
    end
  end

  def show
    @user = User.find params[:id]
    respond_to do |format|
      format.html
      format.json { render json: @user.to_json(except: :email) }
    end
  end

  private
  def trans_handle_to_page(page, per)
    if page =~ /\A\d+\Z/
      page
    else
      @handle = page
      if user_page = User.find_page_by_handle(page, per)
        user_page
      else
        flash.now[:alert] = "User not found" unless page.blank?
        1
      end
    end
  end
end

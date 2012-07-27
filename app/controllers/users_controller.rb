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

  # GET 
  # users/:id/edit
  def edit
    redirect_to '/' and return unless params[:key]
    claim_key = ClaimIdentityKey.where(key: params[:key]).first
    if claim_key && !claim_key.expired?
      @user = claim_key.user
    else 
      redirect_to '/'
    end
  end

  # PUT
  # users/:id
  def update
    @user = User.find(params[:id])
    @user.update_attributes params[:user]
    redirect_to '/'
  end

  # GET
  # users/:id/claim_identity
  def claim_identity
    @user = User.find(params[:user_id])
    @claim_identity_key = ClaimIdentityKey.new(user: @user)
    @claim_identity_key.save!
    url = edit_user_url(@user, key: @claim_identity_key.key)
    UserMailer.claim_identity(url, @user.email).deliver 
    render partial: 'claim_identity', layout: false
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

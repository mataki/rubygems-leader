class MembershipsController < ApplicationController
  before_filter :load_team

  def create
    @membership = @team.memberships.build(params[:membership])
    if @membership.save
      redirect_to @team, notice: "Added #{@membership.user_name} successfully."
    else
      redirect_to @team, alert: "Failed to add. #{@membership.errors.full_messages.join(' / ')}"
    end
  end

  def destroy
    @membership = @team.memberships.find(params[:id])
    @membership.destroy
    redirect_to @team, notice: "Success to destroy #{@membership.user_name}."
  end

private
  def load_team
    @team = Team.find(params[:team_id])
  end
end

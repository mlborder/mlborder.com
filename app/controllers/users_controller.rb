class UsersController < ApplicationController
  before_action :authenticate_admin!, only: :index
  before_action :set_user, only: %i(show edit update)
  before_action :authenticate_user!, only: %i(show edit update)

  def index
    @users = User.with_profile.includes(:alarms).all
  end

  def edit
    @user.build_profile unless @user.profile
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), flash: { alert: { type: 'success', message: t('.success') } }
    else
      render :edit
    end
  end

  private
  def user_params
    params.fetch(:user).permit(
      :name,
      profile_attributes: [
        :id,
        :player_id,
        :produce_idol_id,
        :description
      ]
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authenticate_user!
    return if current_user.role_admin?

    if current_user.nil? || !is_current_user?(@user)
      redirect_to root_path
    end
  end
end

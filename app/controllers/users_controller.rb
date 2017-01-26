class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:alarms).all
  end
end

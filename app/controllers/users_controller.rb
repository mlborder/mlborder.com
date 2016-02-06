class UsersController < ApplicationController
  include AuthActions
  before_action :authenticate_admin!

  def index
    @users = User.all
  end
end

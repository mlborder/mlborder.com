class SessionsController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to user_path(user), flash: { alert: { type: 'success', message: t('login_succeeded') } }
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

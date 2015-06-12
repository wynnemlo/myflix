class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :user_signed_in?

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def require_user
    if !user_signed_in?
      flash["danger"] = "Access limited to members only. Please kindly log in before you proceed."
      redirect_to root_path
    end
  end
end

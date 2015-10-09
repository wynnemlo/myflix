class SessionsController < ApplicationController
  def new
    redirect_to home_path if user_signed_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash["success"] = "You have successfully logged in."
        redirect_to home_path
      else
        flash["danger"] = "Your account has been suspended. Please contact customer services."
        redirect_to sign_in_path
      end
    else
      flash["danger"] = "There was something wrong with your email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash["success"] = "You have logged out."
    redirect_to root_path
  end
end
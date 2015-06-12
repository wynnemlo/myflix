class SessionsController < ApplicationController
  def new
    redirect_to home_path if user_signed_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash["success"] = "You have successfully logged in."
      redirect_to home_path
    else
      flash["danger"] = "There was something wrong with your email or password."
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash["success"] = "You have logged out."
    redirect_to root_path
  end
end
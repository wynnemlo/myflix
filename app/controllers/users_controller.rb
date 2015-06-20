class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash["success"] = "Thank you for your registration."
      redirect_to sign_in_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end

end
class ReactivationsController < ApplicationController
  expose(:user) do
    params[:user].present? ? User.find_by(email: user_params[:email]) : User.new
  end

  def create
    if user.deactivated? && user.valid_password?(user_params[:password])
      user.update deactivated_at: nil
      user.memberships.create joined_at: Time.current

      sign_in user

      redirect_to root_path, notice: "Your membership to Ruby Australia has been reactivated."
    else
      flash[:notice] = "The provided details are not valid."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

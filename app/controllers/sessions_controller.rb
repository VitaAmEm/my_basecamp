class SessionsController < ApplicationController
  def new
    # Login form page
  end

  def create
    email = params[:email]
    password = params[:password]
    
    user = User.find_by(email: email)
    
    if user.present? && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Logged in successfully!"
    else
      if user.blank?
        flash.now[:alert] = "No account found with that email address"
      else
        flash.now[:alert] = "Invalid password"
      end
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end

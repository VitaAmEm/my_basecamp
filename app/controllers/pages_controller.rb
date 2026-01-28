class PagesController < ApplicationController
  def home
    if logged_in?
      redirect_to user_path(current_user)
    else
      redirect_to new_user_path
    end
  end
end

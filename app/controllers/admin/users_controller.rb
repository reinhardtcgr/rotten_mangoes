class Admin::UsersController < ApplicationController
    
  def index
    if current_user.admin
      @users = User.all
    else
      flash[:alert] = "You must be an Admin to view the Users page!"
      redirect_to movies_path
    end
  end
  
end
